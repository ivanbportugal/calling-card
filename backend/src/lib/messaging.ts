import { getMessaging } from 'firebase-admin/messaging'
import type { StatusColor } from '@prisma/client'
import type { FastifyInstance } from 'fastify'

export async function sendStatusUpdate(
  fcmTokens: string[],
  color: StatusColor,
  displayName: string | null,
  fastify: FastifyInstance
) {
  const log = fastify.log
  if (fcmTokens.length === 0) {
    log.warn(`no tokens for ${displayName}`)
    return
  }
  log.debug(`sending push for ${displayName}, to ${fcmTokens.length} friends`)

  const name = displayName ?? 'A friend'
  const messaging = getMessaging()

  await messaging.sendEach(
    fcmTokens.map((token) => ({
      token,
      notification: {
        title: name,
        body: `${name} is now ${color.toLowerCase()}`,
      },
      data: { type: 'STATUS_UPDATE', color, displayName: name },
    })),
  )
}
