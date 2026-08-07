export default async function friendsRoutes(fastify) {
  fastify.get('/friends', async (request) => {
    const userId = request.user.id

    const friendships = await fastify.prisma.friendship.findMany({
      where: {
        status: 'ACCEPTED',
        OR: [{ requesterId: userId }, { addresseeId: userId }],
      },
      include: { requester: true, addressee: true },
    })

    return friendships.map((friendship) => {
      const friend = friendship.requesterId === userId ? friendship.addressee : friendship.requester

      return {
        id: friend.id,
        displayName: friend.displayName,
        email: friend.email,
        photoUrl: friend.photoUrl,
      }
    })
  })
}
