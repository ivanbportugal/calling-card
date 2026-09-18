import type { FastifyBaseLogger, FastifyInstance } from 'fastify'
import type { PrismaClient, StatusColor } from '@prisma/client'
import { sendStatusUpdate } from '../lib/messaging.ts'

const VALID_COLORS = new Set<StatusColor>(['GREEN', 'YELLOW', 'RED'])

async function notifyFriends(
  prisma: PrismaClient,
  userId: string,
  displayName: string | null,
  color: StatusColor,
  fastify: FastifyInstance
) {
  const friendships = await prisma.friendship.findMany({
    where: {
      status: 'ACCEPTED',
      OR: [{ requesterId: userId }, { addresseeId: userId }],
    },
    include: {
      requester: { select: { id: true, fcmToken: true } },
      addressee: { select: { id: true, fcmToken: true } },
    },
  })

  const fcmTokens = friendships
    .map((f) => (f.requesterId === userId ? f.addressee : f.requester))
    .map((u) => u.fcmToken)
    .filter((t): t is string => !!t)

  await sendStatusUpdate(fcmTokens, color, displayName, fastify)
}

export default async function statusRoutes(fastify: FastifyInstance) {
  fastify.get('/status', async (request, reply) => {
    const status = await fastify.prisma.userStatus.findUnique({
      where: { userId: request.user.id },
    })

    if (!status) {
      return reply.code(404).send({ error: 'user status not found' })
    }
    return { color: status.color }
  })

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

    await notifyFriends(fastify.prisma, request.user.id, request.user.displayName, status.color, fastify)

    return { color: status.color }
  })
}
