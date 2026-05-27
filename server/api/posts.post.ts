import { db } from "../db";
import { posts } from "../db/schema";

export default defineEventHandler(async (event) => {

	const { content, topicId } = await readBody(event);
	const session = await getUserSession(event);
	const userId = session.user.id;

	const [topic] = await db
		.insert(posts)
		.values({ content, topicId, userId })
		.returning();
	return topic;

});
