import { db } from "../../db";
import { topics, users, categories } from "../../db/schema";
import { eq } from "drizzle-orm";

export default defineEventHandler(async (event) => {
  const { categoryId } = getQuery(event);

  const base = db
    .select({
      id: topics.id,
      title: topics.title,
      description: topics.description,
      username: users.username,
      categoryId: topics.categoryId,
      categoryName: categories.name,
      isResolved: topics.isResolved,
      createdAt: topics.createdAt,
      avatarUrl: users.avatarUrl,
    })
    .from(topics)
    .leftJoin(users, eq(topics.userId, users.id))
    .leftJoin(categories, eq(topics.categoryId, categories.id));

  if (categoryId) {
    return base.where(eq(topics.categoryId, categoryId as string));
  }

  return base;
});
