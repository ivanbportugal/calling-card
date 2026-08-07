import fp from 'fastify-plugin'

export default fp(async (fastify) => {
  fastify.decorateRequest('user', null)

  fastify.addHook('onRequest', async (request, reply) => {
    const header = request.headers.authorization
    const token = header?.startsWith('Bearer ') ? header.slice(7) : null

    if (!token) {
      return reply.code(401).send({ error: 'Missing Bearer token' })
    }

    let decoded
    try {
      decoded = await fastify.verifyIdToken(token)
    } catch (err) {
      return reply.code(401).send({ error: 'Invalid or expired token' })
    }

    request.user = await fastify.prisma.user.upsert({
      where: { firebaseUid: decoded.uid },
      update: { email: decoded.email ?? undefined },
      create: { firebaseUid: decoded.uid, email: decoded.email ?? null },
    })
  })
})
