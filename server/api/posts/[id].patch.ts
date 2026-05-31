import { db } from "../../db"
import { posts } from "../../db/schema"
import { eq } from "drizzle-orm"
import { hasPermission } from "#shared/utils/permissions"


export default defineEventHandler(async (event) => {
	const postId = getRouterParam(event, "id");
	const session = await getUserSession(event);
	const { content } = await readBody(event);

	if (!session.user) {
		throw createError({ statusCode: 401, message: "Not authenticated" });
	}

	const [post] = await db.select().from(posts).where(eq(posts.id, postId!));

	const isOwn = (post.userId === session.user.id);
	const canEdit = isOwn && hasPermission(session.user.permissions, "editOwnContent");

	if (!canEdit) {
		throw createError({ statusCode: 403, message: "Forbidden" });
	}

	await db.update(posts).set({ content }).where(eq(posts.id, postId!));
})
