const VALID_COLORS = new Set(['GREEN', 'YELLOW', 'RED'])

export default async function statusRoutes(fastify) {
  fastify.post('/status', async (request, reply) => {
    const { color } = request.body ?? {}

    if (!VALID_COLORS.has(color)) {
      return reply.code(400).send({ error: 'color must be one of GREEN, YELLOW, RED' })
    }

    const status = await fastify.prisma.userStatus.upsert({
      where: { userId: request.user.id },
      update: { color },
      create: { userId: request.user.id, color },
    })

    return { color: status.color }
  })
}
