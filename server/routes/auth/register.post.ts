import { db } from "../../db";
import { users, roles } from "../../db/schema";
import { eq } from "drizzle-orm";
import bcrypt from "bcrypt";
import type { Permissions } from "#shared/utils/permissions";
import { generateToken, tokenExpiry } from '../../utils/token'
import { sendVerificationMail } from '../../utils/mailer'

export default defineEventHandler(async (event) => {
  const { username, email, password, specialty, verificationDocument } = await readBody(event);

  const [userRole] = await db.select().from(roles).where(eq(roles.name, "user"));
  if (!userRole) {
    throw createError({ statusCode: 500, message: "Roles not seeded. Run npm run db:seed first." });
  }

  const hashed = await bcrypt.hash(password, 12);
  const verifyToken = generateToken();
  const verifyTokenExpiry = tokenExpiry(24);

  const [user] = await db
    .insert(users)
    .values({ username, email, password: hashed, specialty, verificationDocument, roleId: userRole.id, verifyToken, verifyTokenExpiry })
    .returning({
      id: users.id,
      email: users.email,
      username: users.username,
    });

  await sendVerificationMail(email, verifyToken);

  await setUserSession(event, {
    user: {
      id: user.id,
      email: user.email,
      username: user.username,
      role: userRole.name,
      permissions: userRole.permissions as Permissions,
      isVerified: false,
    },
  });

  return { success: true };
});
