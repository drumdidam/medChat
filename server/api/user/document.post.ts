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
  const file = form.get("document") as File;

  if (!file || !file.size) {
    throw createError({ statusCode: 400, message: "No file uploaded" });
  }

  if (!file.type.startsWith("image/") && file.type !== "application/pdf") {
    throw createError({ statusCode: 400, message: "Only images and PDFs allowed" });
  }

  const ext = file.name.split(".").pop();
  const filename = `${session.user.id}-${Date.now()}.${ext}`;

  const buffer = Buffer.from(await file.arrayBuffer());
  await writeFile(join(process.cwd(), "private", "documents", filename), buffer);

  const verificationDocument = `/private/documents/${filename}`;

  await db
    .update(users)
    .set({ verificationDocument })
    .where(eq(users.id, session.user.id));

  return { verificationDocument };
});
