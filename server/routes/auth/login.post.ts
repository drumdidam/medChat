import { db } from "../../db";
import { users } from "../../db/schema";
import { eq } from "drizzle-orm";
import bcrypt from "bcrypt";

export default defineEventHandler(async (event) => {
  const body = await readBody(event);
  const { email, password } = body;

  // console.log("[login] attempt for:", email);

  const [user] = await db.select().from(users).where(eq(users.email, email));

  if (!user) {
    // console.log("[login] user not found:", email);
    throw createError({ statusCode: 401, message: "Invalid credentials" });
  }

  const valid = await bcrypt.compare(password, user.password);
  if (!valid) {
    // console.log("[login] wrong password for:", email);
    throw createError({ statusCode: 401, message: "Invalid credentials" });
  }

  // console.log("[login] setting session for user id:", user.id);
  await setUserSession(event, {
    user: { id: user.id, email: user.email },
  });
  // console.log("[login] session set successfully");

  return { success: true };
});
