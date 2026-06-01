import { db } from "../../db";
import { topics } from "../../db/schema";
import { eq } from "drizzle-orm";
import { hasPermission } from "#shared/utils/permissions";

export default defineEventHandler(async (event) => {
  const topicId = getRouterParam(event, "id");
  const session = await getUserSession(event);

  if (!session.user) {
    throw createError({ statusCode: 401, message: "Not authenticated" });
  }

  if (!hasPermission(session.user.permissions, "markResolved")) {
    throw createError({ statusCode: 403, message: "Forbidden" });
  }

  const [topic] = await db.select().from(topics).where(eq(topics.id, topicId!));

  if (!topic) {
    throw createError({ statusCode: 404, message: "Topic not found" });
  }

  const [updated] = await db
    .update(topics)
    .set({ isResolved: !topic.isResolved })
    .where(eq(topics.id, topicId!))
    .returning();

  return updated;
});
