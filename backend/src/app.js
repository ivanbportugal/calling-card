import Fastify from 'fastify'
import 'pino-pretty'
import authPlugin from './plugins/auth.js'
import profileRoutes from './routes/profile.js'
import friendsRoutes from './routes/friends.js'
import friendRequestRoutes from './routes/friendRequests.js'
import statusRoutes from './routes/status.js'
import { prisma as defaultPrisma } from './lib/prisma.js'
import { verifyIdToken as defaultVerifyIdToken } from './lib/firebase.js'

export async function buildApp({ prisma = defaultPrisma, verifyIdToken = defaultVerifyIdToken } = {}) {
  const fastify = Fastify({
    logger: {
      transport: {
        target: 'pino-pretty',
      }
    }
  })

  fastify.decorate('prisma', prisma)
  fastify.decorate('verifyIdToken', verifyIdToken)

  fastify.get('/health', async () => ({ status: 'ok' }))

  fastify.register(
    async (instance) => {
      await instance.register(authPlugin)
      await instance.register(profileRoutes)
      await instance.register(friendsRoutes)
      await instance.register(friendRequestRoutes)
      await instance.register(statusRoutes)
    },
    { prefix: '/api' },
  )
  fastify.log.debug("what's going on")

  return fastify
}

// For serverless
export default async function handler(req, res) {
  const app = await buildApp();
  await app.ready();
  app.server.emit('request', req, res);
}
