import type { FastifyInstance } from 'fastify'

export default async function friendsRoutes(fastify: FastifyInstance) {
  fastify.get<{ Querystring: { email?: string } }>('/friends/search', async (request, reply) => {
    const { email } = request.query ?? {}

    if (!email || typeof email !== 'string') {
      return reply.code(400).send({ error: 'email is required' })
    }

    const user = await fastify.prisma.user.findFirst({
      where: { email: { equals: email, mode: 'insensitive' } },
    })

    if (!user) {
      return reply.code(404).send({ error: 'user not found' })
    }

    return {
      id: user.id,
      displayName: user.displayName,
      email: user.email,
      photoUrl: user.photoUrl,
    }
  })

  fastify.get('/friends', async (request) => {
    const userId = request.user.id

    const friendships = await fastify.prisma.friendship.findMany({
      where: {
        status: 'ACCEPTED',
        OR: [{ requesterId: userId }, { addresseeId: userId }],
      },
      include: {
        requester: { include: { status: true } },
        addressee: { include: { status: true } },
      },
    })

    return friendships.map((friendship) => {
      const friend = friendship.requesterId === userId ? friendship.addressee : friendship.requester

      return {
        id: friend.id,
        displayName: friend.displayName,
        email: friend.email,
        photoUrl: friend.photoUrl,
        status: friend.status?.color ?? null,
      }
    })
  })

  fastify.delete<{ Params: { id: string } }>('/friends/:id', async (request, reply) => {
    const userId = request.user.id
    const { id: friendId } = request.params

    const friendship = await fastify.prisma.friendship.findFirst({
      where: {
        status: 'ACCEPTED',
        OR: [
          { requesterId: userId, addresseeId: friendId },
          { requesterId: friendId, addresseeId: userId },
        ],
      },
    })

    if (!friendship) {
      return reply.code(404).send({ error: 'friendship not found' })
    }

    await fastify.prisma.friendship.delete({ where: { id: friendship.id } })

    return reply.code(204).send()
  })
}
