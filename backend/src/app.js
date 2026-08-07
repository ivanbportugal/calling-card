import Fastify from 'fastify'
import profileRoutes from './routes/profile.js'

export function buildApp() {
  const fastify = Fastify({ logger: true })

  fastify.get('/health', async () => ({ status: 'ok' }))

  fastify.register(profileRoutes, { prefix: '/api' })

  return fastify
}
