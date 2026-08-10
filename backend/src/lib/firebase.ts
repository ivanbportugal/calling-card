import { initializeApp, applicationDefault, getApps } from 'firebase-admin/app'
import { getAuth } from 'firebase-admin/auth'

if (!getApps().length) {
  initializeApp({
    credential: applicationDefault(),
  })
}

export const auth = getAuth()

export function verifyIdToken(token: string) {
  return auth.verifyIdToken(token)
}
