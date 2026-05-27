import { db } from "../db";
import { topics, categories, users } from "../db/schema";
import { ilike, or, eq } from "drizzle-orm";

export default defineEventHandler(async (event) => {
	const { q } = getQuery(event);

	if (!q || (q as string).trim().length < 2) return [];

	return db
		.select({
			id: topics.id,
			title: topics.title,
			description: topics.description,
			categoryName: categories.name,
			categoryId: topics.categoryId,
			username: users.username,
		})
		.from(topics)
		.leftJoin(categories, eq(topics.categoryId, categories.id))
		.leftJoin(users, eq(topics.userId, users.id))
		.where(
			or(
				ilike(topics.title, `%${q}%`),
				ilike(topics.description, `%${q}%`)
			)
		)
		.limit(20);
});
