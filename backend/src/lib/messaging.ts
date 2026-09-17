import { getMessaging } from 'firebase-admin/messaging'
import type { StatusColor } from '@prisma/client'

export async function sendStatusUpdate(
  fcmTokens: string[],
  color: StatusColor,
  displayName: string | null,
) {
  if (fcmTokens.length === 0) {
    return
  }

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
