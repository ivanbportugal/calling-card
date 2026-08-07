import authPlugin from '../plugins/auth.js'

export default async function profileRoutes(fastify) {
  await fastify.register(authPlugin)

  fastify.get('/profile', async (request) => {
    return request.user
  })
}
