import Fastify from 'fastify'
import authPlugin from './plugins/auth.js'
import profileRoutes from './routes/profile.js'
import friendsRoutes from './routes/friends.js'
import { prisma as defaultPrisma } from './lib/prisma.js'
import { verifyIdToken as defaultVerifyIdToken } from './lib/firebase.js'

export function buildApp({ prisma = defaultPrisma, verifyIdToken = defaultVerifyIdToken } = {}) {
  const fastify = Fastify({ logger: true })

  fastify.decorate('prisma', prisma)
  fastify.decorate('verifyIdToken', verifyIdToken)

  fastify.get('/health', async () => ({ status: 'ok' }))

  fastify.register(
    async (instance) => {
      await instance.register(authPlugin)
      await instance.register(profileRoutes)
      await instance.register(friendsRoutes)
    },
    { prefix: '/api' },
  )

  return fastify
}
