import { db } from "../../db";
import { users } from "../../db/schema";
import bcrypt from "bcrypt";

export default defineEventHandler(async (event) => {
  const { username, email, password, specialty, verificationDocument } = await readBody(event);

  const hashed = await bcrypt.hash(password, 12);

  const [user] = await db
    .insert(users)
    .values({ username, email, password: hashed, specialty, verificationDocument })
    .returning({ id: users.id, email: users.email });

  await setUserSession(event, {
    user: { id: user.id, email: user.email },
  });

  return { success: true };
});
