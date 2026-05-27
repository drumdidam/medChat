import { db } from "../db";
import { topics } from "../db/schema";

export default defineEventHandler(async (event) => {

	const { title, description } = await readBody(event);
	const session = await getUserSession(event);
	const userId = session.user.id;

	const [topic] = await db
		.insert(topics)
		.values({ title, description, userId })
		.returning();
	return topic;

});
