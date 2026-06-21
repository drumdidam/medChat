import { db } from "../../db";
import { topics, users, categories } from "../../db/schema";
import { eq, desc } from "drizzle-orm";

export default defineEventHandler(async (event) => {
  const query = getQuery(event);
  const { categoryId } = query;

  const page = Math.max(1, Number(query.page) || 1);
  const limit = Math.min(100, Math.max(1, Number(query.limit) || 20));
  const offset = (page - 1) * limit;

  const where = categoryId
    ? eq(topics.categoryId, categoryId as string)
    : undefined;

  const items = await db
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
      userId: users.id,
    })
    .from(topics)
    .leftJoin(users, eq(topics.userId, users.id))
    .leftJoin(categories, eq(topics.categoryId, categories.id))
    .where(where)
    .orderBy(desc(topics.createdAt))
    .limit(limit)
    .offset(offset);

  const total = await db.$count(topics, where);

  return { items, total, page, limit };
});
