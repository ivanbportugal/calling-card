import Fastify from 'fastify'
import fastifyStatic from '@fastify/static'
import 'pino-pretty'
import type { PrismaClient } from '@prisma/client'
import type { IncomingMessage, ServerResponse } from 'node:http'
import type { VerifiedToken } from './types/fastify.ts'
import authPlugin from './plugins/auth.ts'
import profileRoutes from './routes/profile.ts'
import friendsRoutes from './routes/friends.ts'
import friendRequestRoutes from './routes/friendRequests.ts'
import statusRoutes from './routes/status.ts'
import { prisma as defaultPrisma } from './lib/prisma.ts'
import { verifyIdToken as defaultVerifyIdToken } from './lib/firebase.ts'
import path from 'path'

type BuildAppOptions = {
  prisma?: PrismaClient
  verifyIdToken?: (token: string) => Promise<VerifiedToken>
}

export async function buildApp({ prisma = defaultPrisma, verifyIdToken = defaultVerifyIdToken }: BuildAppOptions = {}) {
  const fastify = Fastify({
    logger: {
      transport: {
        target: 'pino-pretty',
      }
    }
  })

  fastify.decorate('prisma', prisma)
  fastify.decorate('verifyIdToken', verifyIdToken)

  fastify.get('/api/health', async () => ({ status: 'ok' }))

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

  fastify.register(fastifyStatic, {
    root: path.join(process.cwd(), 'public'),
  })
  fastify.get('/', async (request, reply) => {
    return reply.sendFile('index.html');
  });

  fastify.log.debug("Fastify setup complete")

  return fastify
}

// For serverless
export default async function handler(req: IncomingMessage, res: ServerResponse) {
  const app = await buildApp();
  await app.ready();
  app.server.emit('request', req, res);
}
