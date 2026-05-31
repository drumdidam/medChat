import { db } from "../db";
import { topics } from "../db/schema";
import { hasPermission } from "#shared/utils/permissions";

export default defineEventHandler(async (event) => {
  const session = await getUserSession(event);

  if (!session.user) {
    throw createError({ statusCode: 401, message: "Not authenticated" });
  }

  if (!hasPermission(session.user.permissions, "createTopic")) {
    throw createError({ statusCode: 403, message: "Forbidden" });
  }

  const { title, description, categoryId } = await readBody(event);

  const [topic] = await db
    .insert(topics)
    .values({ title, description, userId: session.user.id, categoryId: categoryId ?? null })
    .returning();

  return topic;
});
