import 'dotenv/config'
import { buildApp } from './app.ts'

const app = await buildApp()

if (process.env.ENVIRONMENT === 'local') {
  app.log.info("launching local env")
  const port = Number(process.env.PORT) || 3000

  try {
    await app.listen({ port, host: '0.0.0.0' })
  } catch (err) {
    app.log.error(err)
    process.exit(1)
  }
} else {
  app.log.info("launching serverless")
}
