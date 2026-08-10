import { execFileSync } from 'node:child_process'
import { PostgreSqlContainer } from '@testcontainers/postgresql'
import { PrismaClient } from '@prisma/client'
import { PrismaPg } from '@prisma/adapter-pg'

export async function startTestDb() {
  const container = await new PostgreSqlContainer('postgres:16-alpine').start()
  const connectionString = container.getConnectionUri()

  execFileSync('node_modules/.bin/prisma', ['migrate', 'deploy'], {
    env: { ...process.env, DATABASE_URL: connectionString },
    stdio: 'inherit',
  })

  const prisma = new PrismaClient({ adapter: new PrismaPg({ connectionString }) })

  return {
    prisma,
    async reset() {
      await prisma.friendship.deleteMany()
      await prisma.user.deleteMany()
    },
    async stop() {
      await prisma.$disconnect()
      await container.stop()
    },
  }
}
