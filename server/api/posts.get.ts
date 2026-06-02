import { db } from "../db";
import { posts, users, topics } from "../db/schema";
import { eq } from "drizzle-orm";

export default defineEventHandler(async (event) => {

	const { topicId } = getQuery(event);

	const allPosts = await db
		.select({
			id: posts.id,
			content: posts.content,
			createdAt: posts.createdAt,
			userId: posts.userId,
			username: users.username,
			avatarUrl: users.avatarUrl,
			TopicTitle: topics.title,
			isResolved: topics.isResolved,
			attachments: posts.attachments,
		})
		.from(posts)
		.leftJoin(users, eq(posts.userId, users.id))
		.leftJoin(topics, eq(posts.topicId, topics.id))
		.where(eq(posts.topicId, topicId as string));

	return allPosts;

});
