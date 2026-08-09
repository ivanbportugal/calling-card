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

test('GET /api/profile returns', async (t) => {
  const { prisma } = testDb

  const ana = await prisma.user.create({ data: { firebaseUid: 'ana-uid', displayName: 'Ana', email: 'ana@example.com' } })
  
  const app = await buildApp({
    prisma,
    verifyIdToken: fakeVerifyIdToken({
        'ana-token': ana.firebaseUid,
    }),
  })
  await app.ready()
  t.after(() => app.close())

  const res = await app.inject({
    method: 'GET',
    url: '/api/profile',
    headers: { authorization: 'Bearer ana-token' },
  })

  assert.equal(res.statusCode, 200)

  const body = res.json()

  assert.partialDeepStrictEqual(body, {
    firebaseUid: 'ana-uid',
    displayName: 'Ana'
  })
})

test('GET /api/profile 401', async (t) => {
  const { prisma } = testDb

  const app = await buildApp({
    prisma,
  })
  await app.ready()
  t.after(() => app.close())

  const res = await app.inject({
    method: 'GET',
    url: '/api/profile',
    headers: { authorization: 'Bearer unknown-token' },
  })

  assert.equal(res.statusCode, 401)
})

test('POST /api/profile updates', async (t) => {
  const { prisma } = testDb

  const ana = await prisma.user.create({ data: { firebaseUid: 'ana-uid', displayName: 'Ana', email: 'ana@example.com' } })
  
  const app = await buildApp({
    prisma,
    verifyIdToken: fakeVerifyIdToken({
        'ana-token': ana.firebaseUid,
    }),
  })
  await app.ready()
  t.after(() => app.close())

  let res = await app.inject({
    method: 'POST',
    url: '/api/profile',
    headers: { authorization: 'Bearer ana-token' },
    body: {
        fcmToken: 'fcm-token',
        displayName: 'The Ana',
        phoneNumber: '5553459785'
    }
  })

  assert.equal(res.statusCode, 200)

  res = await app.inject({
    method: 'GET',
    url: '/api/profile',
    headers: { authorization: 'Bearer ana-token' },
  })

  const body = res.json()

  assert.partialDeepStrictEqual(body, {
    firebaseUid: 'ana-uid',
    fcmToken: 'fcm-token',
    displayName: 'The Ana',
    phoneNumber: '5553459785'
  })
})
