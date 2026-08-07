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

async function createUsers(prisma) {
  const ana = await prisma.user.create({ data: { firebaseUid: 'ana-uid', displayName: 'Ana' } })
  const jessica = await prisma.user.create({ data: { firebaseUid: 'jessica-uid', displayName: 'Jessica' } })
  return { ana, jessica }
}

test('GET /api/friends/requests separates incoming from outgoing pending requests', async (t) => {
  const { prisma } = testDb
  const { ana, jessica } = await createUsers(prisma)
  const jo = await prisma.user.create({ data: { firebaseUid: 'jo-uid', displayName: 'Jo' } })
  const bethany = await prisma.user.create({ data: { firebaseUid: 'bethany-uid', displayName: 'Bethany' } })

  // Ana -> Jessica (outgoing for Ana)
  await prisma.friendship.create({ data: { requesterId: ana.id, addresseeId: jessica.id, status: 'PENDING' } })
  // Jo -> Ana (incoming for Ana)
  await prisma.friendship.create({ data: { requesterId: jo.id, addresseeId: ana.id, status: 'PENDING' } })
  // Already-accepted friendship should not show up as a pending request
  await prisma.friendship.create({ data: { requesterId: ana.id, addresseeId: bethany.id, status: 'ACCEPTED' } })

  const app = buildApp({ prisma, verifyIdToken: fakeVerifyIdToken({ 'ana-token': ana.firebaseUid }) })
  await app.ready()
  t.after(() => app.close())

  const res = await app.inject({
    method: 'GET',
    url: '/api/friends/requests',
    headers: { authorization: 'Bearer ana-token' },
  })

  assert.equal(res.statusCode, 200)
  const body = res.json()

  assert.equal(body.incoming.length, 1)
  assert.equal(body.incoming[0].user.displayName, 'Jo')

  assert.equal(body.outgoing.length, 1)
  assert.equal(body.outgoing[0].user.displayName, 'Jessica')
})

test('GET /api/friends/requests requires a Bearer token', async (t) => {
  const app = buildApp({ prisma: testDb.prisma, verifyIdToken: fakeVerifyIdToken({}) })
  await app.ready()
  t.after(() => app.close())

  const res = await app.inject({ method: 'GET', url: '/api/friends/requests' })

  assert.equal(res.statusCode, 401)
})

test('POST /api/friends/requests creates a pending friend request', async (t) => {
  const { prisma } = testDb
  const { ana, jessica } = await createUsers(prisma)

  const app = buildApp({ prisma, verifyIdToken: fakeVerifyIdToken({ 'ana-token': ana.firebaseUid }) })
  await app.ready()
  t.after(() => app.close())

  const res = await app.inject({
    method: 'POST',
    url: '/api/friends/requests',
    headers: { authorization: 'Bearer ana-token' },
    payload: { addresseeId: jessica.id },
  })

  assert.equal(res.statusCode, 201)
  const body = res.json()
  assert.equal(body.requesterId, ana.id)
  assert.equal(body.addresseeId, jessica.id)
  assert.equal(body.status, 'PENDING')

  const stored = await prisma.friendship.findUnique({ where: { id: body.id } })
  assert.equal(stored.status, 'PENDING')
})

test('POST /api/friends/requests rejects sending a request to yourself', async (t) => {
  const { prisma } = testDb
  const { ana } = await createUsers(prisma)

  const app = buildApp({ prisma, verifyIdToken: fakeVerifyIdToken({ 'ana-token': ana.firebaseUid }) })
  await app.ready()
  t.after(() => app.close())

  const res = await app.inject({
    method: 'POST',
    url: '/api/friends/requests',
    headers: { authorization: 'Bearer ana-token' },
    payload: { addresseeId: ana.id },
  })

  assert.equal(res.statusCode, 400)
})

test('POST /api/friends/requests 404s when the target user does not exist', async (t) => {
  const { prisma } = testDb
  const { ana } = await createUsers(prisma)

  const app = buildApp({ prisma, verifyIdToken: fakeVerifyIdToken({ 'ana-token': ana.firebaseUid }) })
  await app.ready()
  t.after(() => app.close())

  const res = await app.inject({
    method: 'POST',
    url: '/api/friends/requests',
    headers: { authorization: 'Bearer ana-token' },
    payload: { addresseeId: 'does-not-exist' },
  })

  assert.equal(res.statusCode, 404)
})

test('POST /api/friends/requests 409s on a duplicate request in either direction', async (t) => {
  const { prisma } = testDb
  const { ana, jessica } = await createUsers(prisma)
  await prisma.friendship.create({ data: { requesterId: ana.id, addresseeId: jessica.id, status: 'PENDING' } })

  const app = buildApp({
    prisma,
    verifyIdToken: fakeVerifyIdToken({ 'ana-token': ana.firebaseUid, 'jessica-token': jessica.firebaseUid }),
  })
  await app.ready()
  t.after(() => app.close())

  const resSameDirection = await app.inject({
    method: 'POST',
    url: '/api/friends/requests',
    headers: { authorization: 'Bearer ana-token' },
    payload: { addresseeId: jessica.id },
  })
  assert.equal(resSameDirection.statusCode, 409)

  const resReverseDirection = await app.inject({
    method: 'POST',
    url: '/api/friends/requests',
    headers: { authorization: 'Bearer jessica-token' },
    payload: { addresseeId: ana.id },
  })
  assert.equal(resReverseDirection.statusCode, 409)
})

test('POST /api/friends/requests/:id/accept lets only the addressee accept, then friends can see each other', async (t) => {
  const { prisma } = testDb
  const { ana, jessica } = await createUsers(prisma)
  const request_ = await prisma.friendship.create({
    data: { requesterId: ana.id, addresseeId: jessica.id, status: 'PENDING' },
  })

  const app = buildApp({
    prisma,
    verifyIdToken: fakeVerifyIdToken({ 'ana-token': ana.firebaseUid, 'jessica-token': jessica.firebaseUid }),
  })
  await app.ready()
  t.after(() => app.close())

  // the requester cannot accept their own request
  const forbidden = await app.inject({
    method: 'POST',
    url: `/api/friends/requests/${request_.id}/accept`,
    headers: { authorization: 'Bearer ana-token' },
  })
  assert.equal(forbidden.statusCode, 403)

  const accepted = await app.inject({
    method: 'POST',
    url: `/api/friends/requests/${request_.id}/accept`,
    headers: { authorization: 'Bearer jessica-token' },
  })
  assert.equal(accepted.statusCode, 200)
  assert.equal(accepted.json().status, 'ACCEPTED')

  const anaFriends = await app.inject({
    method: 'GET',
    url: '/api/friends',
    headers: { authorization: 'Bearer ana-token' },
  })
  assert.deepEqual(
    anaFriends.json().map((f) => f.displayName),
    ['Jessica'],
  )
})

test('POST /api/friends/requests/:id/accept 409s when the request is already accepted', async (t) => {
  const { prisma } = testDb
  const { ana, jessica } = await createUsers(prisma)
  const request_ = await prisma.friendship.create({
    data: { requesterId: ana.id, addresseeId: jessica.id, status: 'ACCEPTED' },
  })

  const app = buildApp({ prisma, verifyIdToken: fakeVerifyIdToken({ 'jessica-token': jessica.firebaseUid }) })
  await app.ready()
  t.after(() => app.close())

  const res = await app.inject({
    method: 'POST',
    url: `/api/friends/requests/${request_.id}/accept`,
    headers: { authorization: 'Bearer jessica-token' },
  })

  assert.equal(res.statusCode, 409)
})

test('POST /api/friends/requests/:id/accept 404s for an unknown request id', async (t) => {
  const { prisma } = testDb
  const { jessica } = await createUsers(prisma)

  const app = buildApp({ prisma, verifyIdToken: fakeVerifyIdToken({ 'jessica-token': jessica.firebaseUid }) })
  await app.ready()
  t.after(() => app.close())

  const res = await app.inject({
    method: 'POST',
    url: '/api/friends/requests/00000000-0000-0000-0000-000000000000/accept',
    headers: { authorization: 'Bearer jessica-token' },
  })

  assert.equal(res.statusCode, 404)
})
