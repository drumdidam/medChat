import { db } from "../db";
import { posts, users } from "../db/schema";
import { eq } from "drizzle-orm";

export default defineEventHandler(async (event) => {

	const { topicId } = getQuery(event);

	const allPosts = await db
		.select({
			id: posts.id,
			content: posts.content,
			createdAt: posts.createdAt,
			username: users.username,
		})
		.from(posts)
		.leftJoin(users, eq(posts.userId, users.id))
		.where(eq(posts.topicId, topicId as string));

	return allPosts;

});
