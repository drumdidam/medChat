import { db } from "../../db";
import { users, roles } from "../../db/schema";
import { eq } from "drizzle-orm";
import bcrypt from "bcrypt";
import type { Permissions } from "#shared/utils/permissions";

export default defineEventHandler(async (event) => {
  const body = await readBody(event);
  const { email, password } = body;

  const [user] = await db
    .select({
      id: users.id,
      email: users.email,
      username: users.username,
      password: users.password,
      isVerified: users.isVerified,
      roleName: roles.name,
      permissions: roles.permissions,
    })
    .from(users)
    .leftJoin(roles, eq(users.roleId, roles.id))
    .where(eq(users.email, email));

  if (!user) {
    throw createError({ statusCode: 401, message: "Invalid credentials" });
  }

  const valid = await bcrypt.compare(password, user.password);
  if (!valid) {
    throw createError({ statusCode: 401, message: "Invalid credentials" });
  }

  await setUserSession(event, {
    user: {
      id: user.id,
      email: user.email,
      username: user.username,
      role: user.roleName ?? "guest",
      permissions: (user.permissions ?? {}) as Permissions,
      isVerified: user.isVerified ?? false,
    },
  });

  return { success: true };
});
