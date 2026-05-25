import { db } from "../../db";
import { users } from "../../db/schema";
import { eq } from "drizzle-orm";
import bcrypt from "bcrypt";

export default defineEventHandler(async (event) => {
  const { email, password } = await readBody(event);

  const [user] = await db.select().from(users).where(eq(users.email, email));

  if (!user) {
    throw createError({ statusCode: 401, message: "Invalid credentials" });
  }

  const valid = await bcrypt.compare(password, user.password);
  if (!valid) {
    throw createError({ statusCode: 401, message: "Invalid credentials" });
  }

  await setUserSession(event, {
    user: { id: user.id, email: user.email },
  });

  return { success: true };
});
