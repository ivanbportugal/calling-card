export default async function profileRoutes(fastify) {
  fastify.get('/profile', async (request, reply) => {
    const firebaseUid = request.user.firebaseUid

    const user = await fastify.prisma.user.findUnique({
      where: {
        firebaseUid
      }
    })
    if (!user) {
      return reply.code(404).send({ error: 'user not found' })
    }
    return user
  })

  fastify.post('/profile', async (request, reply) => {
    const firebaseUid = request.user.firebaseUid

    const user = await fastify.prisma.user.findUnique({
      where: {
        firebaseUid
      }
    })
    if (!user) {
      return reply.code(404).send({ error: 'user not found' })
    }

    const { fcmToken, displayName, phoneNumber } = request.body ?? {}
    const accepted = await fastify.prisma.user.update({
      where: { firebaseUid },
      data: {
        fcmToken, displayName, phoneNumber
      }
    })

    return accepted
  })
}
