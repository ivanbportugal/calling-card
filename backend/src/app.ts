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
import fs from 'node:fs';
import { fileURLToPath } from 'node:url';
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

  // debug output dir
  const __filename = fileURLToPath(import.meta.url);
  const __dirname = path.dirname(__filename);
  // const publicDir = path.join(process.cwd(), 'public'); // or path.join(__dirname, 'public')

  // console.log('CWD:', process.cwd());
  // console.log('__dirname:', __dirname);
  // console.log('publicDir exists?', fs.existsSync(publicDir));
  // if (fs.existsSync(publicDir)) {
  //   console.log('public contents:', fs.readdirSync(publicDir));
  //   console.log('index.html exists?', fs.existsSync(path.join(publicDir, 'index.html')));
  // }

  const candidates = [
    path.join(process.cwd(), 'public'),
    path.join(__dirname, 'public'),
    path.join(__dirname, '../public'),
    path.resolve('public'),
  ];

  console.log('=== STATIC DEBUG ===');
  console.log('process.cwd():', process.cwd());
  console.log('__dirname:', __dirname);
  console.log('__filename:', __filename);

  for (const dir of candidates) {
    console.log(`\nChecking: ${dir}`);
    console.log('  exists:', fs.existsSync(dir));
    if (fs.existsSync(dir)) {
      console.log('  contents:', fs.readdirSync(dir));
      console.log('  index.html:', fs.existsSync(path.join(dir, 'index.html')));
    }
  }
  console.log('=== END STATIC DEBUG ===');

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
