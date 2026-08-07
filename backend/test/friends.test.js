import { test, before, after, beforeEach } from 'node:test'
import assert from 'node:assert/strict'
import { buildApp } from '../src/app.js'
import { startTestDb } from '../test-support/testDb.js'

let testDb

before(async () => {
  testDb = await startTestDb()
}, { timeout: 120_000 })

after(async () => {
  await testDb.stop()
})

beforeEach(async () => {
  await testDb.reset()
})

function fakeVerifyIdToken(uidByToken) {
  return async (token) => {
    const uid = uidByToken[token]
    if (!uid) throw new Error('invalid token')
    return { uid }
  }
}

test('GET /api/friends returns only the caller\'s accepted friends, never a friend-of-a-friend', async (t) => {
  const { prisma } = testDb

  const ana = await prisma.user.create({ data: { firebaseUid: 'ana-uid', displayName: 'Ana', email: 'ana@example.com' } })
  const jessica = await prisma.user.create({ data: { firebaseUid: 'jessica-uid', displayName: 'Jessica', email: 'jessica@example.com' } })
  const jo = await prisma.user.create({ data: { firebaseUid: 'jo-uid', displayName: 'Jo', email: 'jo@example.com' } })
  const bethany = await prisma.user.create({ data: { firebaseUid: 'bethany-uid', displayName: 'Bethany', email: 'bethany@example.com' } })

  await prisma.friendship.create({ data: { requesterId: ana.id, addresseeId: jessica.id, status: 'ACCEPTED' } })
  await prisma.friendship.create({ data: { requesterId: jo.id, addresseeId: ana.id, status: 'ACCEPTED' } })
  // Jessica-Bethany link should never surface when Ana asks for her own friends
  await prisma.friendship.create({ data: { requesterId: jessica.id, addresseeId: bethany.id, status: 'ACCEPTED' } })
  // A pending request to Ana should not count as a friend yet
  const stranger = await prisma.user.create({ data: { firebaseUid: 'stranger-uid', displayName: 'Stranger' } })
  await prisma.friendship.create({ data: { requesterId: stranger.id, addresseeId: ana.id, status: 'PENDING' } })

  const app = buildApp({
    prisma,
    verifyIdToken: fakeVerifyIdToken({ 'ana-token': ana.firebaseUid }),
  })
  await app.ready()
  t.after(() => app.close())

  const res = await app.inject({
    method: 'GET',
    url: '/api/friends',
    headers: { authorization: 'Bearer ana-token' },
  })

  assert.equal(res.statusCode, 200)

  const body = res.json()
  assert.deepEqual(
    body.map((f) => f.displayName).sort(),
    ['Jessica', 'Jo'],
  )
  assert.ok(!body.some((f) => f.displayName === 'Bethany'))
  assert.ok(!body.some((f) => f.displayName === 'Stranger'))
})

test('GET /api/friends returns 401 without a Bearer token', async (t) => {
  const app = buildApp({ prisma: testDb.prisma, verifyIdToken: fakeVerifyIdToken({}) })
  await app.ready()
  t.after(() => app.close())

  const res = await app.inject({ method: 'GET', url: '/api/friends' })

  assert.equal(res.statusCode, 401)
})

test('GET /api/friends returns 401 for an invalid token', async (t) => {
  const app = buildApp({ prisma: testDb.prisma, verifyIdToken: fakeVerifyIdToken({}) })
  await app.ready()
  t.after(() => app.close())

  const res = await app.inject({
    method: 'GET',
    url: '/api/friends',
    headers: { authorization: 'Bearer bad-token' },
  })

  assert.equal(res.statusCode, 401)
})
