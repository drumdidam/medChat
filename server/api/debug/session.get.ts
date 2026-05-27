export default defineEventHandler(async (event) => {
  const session = await getUserSession(event)
  const rawCookie = getCookie(event, 'nuxt-session')

  return {
    session,
    hasCookie: !!rawCookie,
    cookiePreview: rawCookie ? rawCookie.substring(0, 30) + '...' : null,
    headers: {
      cookie: getHeader(event, 'cookie') ?? null,
    },
  }
})
