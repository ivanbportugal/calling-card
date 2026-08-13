import type { PrismaClient, User } from '@prisma/client'

export type VerifiedToken = {
  uid: string
  email?: string | null
}

declare module 'fastify' {
  interface FastifyInstance {
    prisma: PrismaClient
    verifyIdToken: (token: string) => Promise<VerifiedToken>
  }

  interface FastifyRequest {
    user: User
  }
}
