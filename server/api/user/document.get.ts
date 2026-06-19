import { db } from "../../db";
import { users } from "../../db/schema";
import { eq } from "drizzle-orm";
import { createReadStream } from "fs";
import { join } from "path";

export default defineEventHandler(async (event) => {
  const session = await getUserSession(event);

  if (!session.user) {
    throw createError({ statusCode: 401, message: "Not authenticated" });
  }

  const [user] = await db
    .select({ verificationDocument: users.verificationDocument })
    .from(users)
    .where(eq(users.id, session.user.id));

  if (!user?.verificationDocument) {
    throw createError({ statusCode: 404, message: "No document found" });
  }

  const filename = user.verificationDocument.split("/").pop()!;
  const filepath = join(process.cwd(), "private", "documents", filename);

  setHeader(event, "Content-Type", contentTypeFor(filename));
  setHeader(event, "Content-Disposition", `inline; filename="${filename}"`);

  return sendStream(event, createReadStream(filepath));
});
