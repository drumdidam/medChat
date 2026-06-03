import { db } from "../../db";
import { users, roles } from "../../db/schema";
import { eq } from "drizzle-orm";

export default defineEventHandler(async (event) => {
  const { token } = getQuery(event)

  if (!token) {
    throw createError({ statusCode: 400, message: 'Kein Token angegeben.' })
  }

  const user = await db.query.users.findFirst({
    where: eq(users.verifyToken, token as string)
  });

  if (!user) {
    throw createError({ statusCode: 400, message: 'Token not valid' })
  }

  if (!user.verifyTokenExpiry || user.verifyTokenExpiry < new Date()) {
    throw createError({ statusCode: 400, message: 'Token expired' })
  }

  if (user.isVerified) {
    return { message: 'E-Mail already verified' }
  }

  await db.update(users).set({
    isVerified: true,
    verifyToken: null,
    verifyTokenExpiry: null,
  }).where(eq(users.id, user.id));

  return { message: 'E-Mail successful verified' }
})
