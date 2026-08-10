import { test, before, after, beforeEach } from 'node:test'
import assert from 'node:assert/strict'
import { buildApp } from '../src/app.ts'
import { startTestDb } from '../test-support/testDb.ts'

let testDb: Awaited<ReturnType<typeof startTestDb>>

before(async () => {
  testDb = await startTestDb()
}, { timeout: 120_000 })

after(async () => {
  await testDb.stop()
})

beforeEach(async () => {
  await testDb.reset()
})

function fakeVerifyIdToken(uidByToken: Record<string, string>) {
  return async (token: string) => {
    const uid = uidByToken[token]
    if (!uid) throw new Error('invalid token')
    return { uid }
  }
}

test('POST /api/status sets and updates the caller\'s status', async (t) => {
  const { prisma } = testDb
  const ana = await prisma.user.create({ data: { firebaseUid: 'ana-uid', displayName: 'Ana' } })

  const app = await buildApp({ prisma, verifyIdToken: fakeVerifyIdToken({ 'ana-token': ana.firebaseUid }) })
  await app.ready()
  t.after(() => app.close())

  const setGreen = await app.inject({
    method: 'POST',
    url: '/api/status',
    headers: { authorization: 'Bearer ana-token' },
    payload: { color: 'GREEN' },
  })
  assert.equal(setGreen.statusCode, 200)
  assert.deepEqual(setGreen.json(), { color: 'GREEN' })

  const stored = await prisma.userStatus.findUnique({ where: { userId: ana.id } })
  assert.equal(stored?.color, 'GREEN')

  // setting again should update the existing row, not create a second one
  const setRed = await app.inject({
    method: 'POST',
    url: '/api/status',
    headers: { authorization: 'Bearer ana-token' },
    payload: { color: 'RED' },
  })
  assert.equal(setRed.statusCode, 200)
  assert.deepEqual(setRed.json(), { color: 'RED' })

  const count = await prisma.userStatus.count({ where: { userId: ana.id } })
  assert.equal(count, 1)
})

test('POST /api/status rejects an invalid color', async (t) => {
  const { prisma } = testDb
  const ana = await prisma.user.create({ data: { firebaseUid: 'ana-uid', displayName: 'Ana' } })

  const app = await buildApp({ prisma, verifyIdToken: fakeVerifyIdToken({ 'ana-token': ana.firebaseUid }) })
  await app.ready()
  t.after(() => app.close())

  const res = await app.inject({
    method: 'POST',
    url: '/api/status',
    headers: { authorization: 'Bearer ana-token' },
    payload: { color: 'PURPLE' },
  })

  assert.equal(res.statusCode, 400)
})

test('POST /api/status requires a Bearer token', async (t) => {
  const app = await buildApp({ prisma: testDb.prisma, verifyIdToken: fakeVerifyIdToken({}) })
  await app.ready()
  t.after(() => app.close())

  const res = await app.inject({ method: 'POST', url: '/api/status', payload: { color: 'GREEN' } })

  assert.equal(res.statusCode, 401)
})

test('GET /api/friends includes each accepted friend\'s status, defaulting to null when unset', async (t) => {
  const { prisma } = testDb

  const ana = await prisma.user.create({ data: { firebaseUid: 'ana-uid', displayName: 'Ana' } })
  const jessica = await prisma.user.create({ data: { firebaseUid: 'jessica-uid', displayName: 'Jessica' } })
  const jo = await prisma.user.create({ data: { firebaseUid: 'jo-uid', displayName: 'Jo' } })

  await prisma.friendship.create({ data: { requesterId: ana.id, addresseeId: jessica.id, status: 'ACCEPTED' } })
  await prisma.friendship.create({ data: { requesterId: jo.id, addresseeId: ana.id, status: 'ACCEPTED' } })

  await prisma.userStatus.create({ data: { userId: jessica.id, color: 'YELLOW' } })
  // Jo never set a status

  const app = await buildApp({ prisma, verifyIdToken: fakeVerifyIdToken({ 'ana-token': ana.firebaseUid }) })
  await app.ready()
  t.after(() => app.close())

  const res = await app.inject({
    method: 'GET',
    url: '/api/friends',
    headers: { authorization: 'Bearer ana-token' },
  })

  assert.equal(res.statusCode, 200)
  const body = res.json()

  const jessicaEntry = body.find((f: { displayName: string }) => f.displayName === 'Jessica')
  const joEntry = body.find((f: { displayName: string }) => f.displayName === 'Jo')

  assert.equal(jessicaEntry.status, 'YELLOW')
  assert.equal(joEntry.status, null)
})
