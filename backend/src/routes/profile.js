export default async function profileRoutes(fastify) {
  fastify.get('/profile', async (request) => {
    return request.user
  })
}
