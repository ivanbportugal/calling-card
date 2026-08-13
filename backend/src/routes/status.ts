import type { FastifyInstance } from 'fastify'
import type { StatusColor } from '@prisma/client'

const VALID_COLORS = new Set<StatusColor>(['GREEN', 'YELLOW', 'RED'])

export default async function statusRoutes(fastify: FastifyInstance) {
  fastify.post<{ Body: { color?: StatusColor } }>('/status', async (request, reply) => {
    const { color } = request.body ?? {}

    if (!color || !VALID_COLORS.has(color)) {
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
