import { db } from "../../db";
import { users } from "../../db/schema";
import { eq } from "drizzle-orm";
import { writeFile } from "fs/promises";
import { join } from "path";

export default defineEventHandler(async (event) => {
  const session = await getUserSession(event);

  if (!session.user) {
    throw createError({ statusCode: 401, message: "Not authenticated" });
  }

  const form = await readFormData(event);
  const file = form.get("avatar") as File;

  if (!file || !file.size) {
    throw createError({ statusCode: 400, message: "No file uploaded" });
  }

  // Only pics 
  if (!file.type.startsWith("image/")) {
    throw createError({ statusCode: 400, message: "Only images allowed" });
  }

  const ext = file.name.split(".").pop();
  const filename = `${session.user.id}-${Date.now()}.${ext}`;

  const buffer = Buffer.from(await file.arrayBuffer());
  await writeFile(join(process.cwd(), "public", "uploads", filename), buffer);

  const avatarUrl = `/uploads/${filename}`;

  await db
    .update(users)
    .set({ avatarUrl })
    .where(eq(users.id, session.user.id));

  return { avatarUrl };
});
