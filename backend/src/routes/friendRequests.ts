import type { FastifyInstance } from 'fastify'
import type { User } from '@prisma/client'

function serializeUser(user: User) {
  return {
    id: user.id,
    displayName: user.displayName,
    email: user.email,
    photoUrl: user.photoUrl,
  }
}

export default async function friendRequestRoutes(fastify: FastifyInstance) {
  fastify.get('/friends/requests', async (request) => {
    const userId = request.user.id

    const [incoming, outgoing] = await Promise.all([
      fastify.prisma.friendship.findMany({
        where: { addresseeId: userId, status: 'PENDING' },
        include: { requester: true },
      }),
      fastify.prisma.friendship.findMany({
        where: { requesterId: userId, status: 'PENDING' },
        include: { addressee: true },
      }),
    ])

    return {
      incoming: incoming.map((f) => ({
        id: f.id,
        createdAt: f.createdAt,
        user: serializeUser(f.requester),
      })),
      outgoing: outgoing.map((f) => ({
        id: f.id,
        createdAt: f.createdAt,
        user: serializeUser(f.addressee),
      })),
    }
  })

  fastify.post<{ Body: { addresseeId?: string } }>('/friends/requests', async (request, reply) => {
    const { addresseeId } = request.body ?? {}
    const requesterId = request.user.id

    if (!addresseeId || typeof addresseeId !== 'string') {
      return reply.code(400).send({ error: 'addresseeId is required' })
    }

    if (addresseeId === requesterId) {
      return reply.code(400).send({ error: 'cannot send a friend request to yourself' })
    }

    const addressee = await fastify.prisma.user.findUnique({ where: { id: addresseeId } })
    if (!addressee) {
      return reply.code(404).send({ error: 'user not found' })
    }

    const existing = await fastify.prisma.friendship.findFirst({
      where: {
        OR: [
          { requesterId, addresseeId },
          { requesterId: addresseeId, addresseeId: requesterId },
        ],
      },
    })

    if (existing) {
      return reply.code(409).send({ error: `friendship already exists with status ${existing.status}` })
    }

    const friendship = await fastify.prisma.friendship.create({
      data: { requesterId, addresseeId, status: 'PENDING' },
    })

    return reply.code(201).send(friendship)
  })

  fastify.post<{ Params: { id: string } }>('/friends/requests/:id/accept', async (request, reply) => {
    const { id } = request.params
    const userId = request.user.id

    const friendship = await fastify.prisma.friendship.findUnique({ where: { id } })

    if (!friendship) {
      return reply.code(404).send({ error: 'friend request not found' })
    }

    if (friendship.addresseeId !== userId) {
      return reply.code(403).send({ error: 'only the recipient can accept this request' })
    }

    if (friendship.status !== 'PENDING') {
      return reply.code(409).send({ error: `friend request is not pending (status: ${friendship.status})` })
    }

    const accepted = await fastify.prisma.friendship.update({
      where: { id },
      data: { status: 'ACCEPTED' },
    })

    return accepted
  })
}
