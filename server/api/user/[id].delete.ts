import { db } from "../../db"
import { users } from "../../db/schema"
import { eq } from "drizzle-orm"
import { hasPermission } from "#shared/utils/permissions"
import bcrypt from "bcrypt";


export default defineEventHandler(async (event) => {
	const userId = getRouterParam(event, "id");
	const session = await getUserSession(event);
	const { password } = await readBody(event);

	if (!session.user) {
		throw createError({ statusCode: 401, message: "Not authenticated" });
	}

	const [user] = await db.select().from(users).where(eq(users.id, userId!));

	console.log("received pw:", password);

	if (!user) {
		throw createError({ statusCode: 404, message: "User not found" });
	}

	const isOwn = user.id === session.user.id;

	if (isOwn) {
		const valid = await bcrypt.compare(password, user.password);
		if (!valid) {
			throw createError({ statusCode: 401, message: "Invalid Password" });
		}
	}
	const canDelete = isOwn
		? hasPermission(session.user.permissions, "deleteOwnContent")
		: hasPermission(session.user.permissions, "deleteAnyContent");

	if (!canDelete) {
		throw createError({ statusCode: 403, message: "Forbidden" });
	}

	await db.delete(users).where(eq(users.id, userId!));
	await clearUserSession(event);
})
