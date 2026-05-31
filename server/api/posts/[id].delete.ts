import { db } from "../../db"
import { posts } from "../../db/schema"
import { eq } from "drizzle-orm"
import { hasPermission } from "#shared/utils/permissions"


export default defineEventHandler(async (event) => {
	const postId = getRouterParam(event, "id");
	const session = await getUserSession(event);

	if (!session.user) {
		throw createError({ statusCode: 401, message: "Not authenticated" });
	}

	const [post] = await db.select().from(posts).where(eq(posts.id, postId!));

	const isOwn = post.userId === session.user.id;
	const canDelete = isOwn
		? hasPermission(session.user.permissions, "deleteOwnContent")
		: hasPermission(session.user.permissions, "deleteAnyContent");

	if (!canDelete) {
		throw createError({ statusCode: 403, message: "Forbidden" });
	}

	await db.delete(posts).where(eq(posts.id, postId!));
})
