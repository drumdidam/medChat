import { db } from "../../db"
import { users, roles } from "../../db/schema"
import { eq } from "drizzle-orm"

export default defineEventHandler(async (event) => {
	const userId = getRouterParam(event, "id")
	const session = await getUserSession(event)

	if (!session.user) {
		throw createError({ statusCode: 401, message: "Not authenticated" })
	}

	const [user] = await db
		.select({
			id: users.id,
			email: users.email,
			username: users.username,
			firstName: users.firstName,
			lastName: users.lastName,
			dateOfBirth: users.dateOfBirth,
			homeCountry: users.homeCountry,
			institution: users.institution,
			specialty: users.specialty,
			verificationDocument: users.verificationDocument,
			avatarUrl: users.avatarUrl,
			roleName: roles.name,
		})
		.from(users)
		.leftJoin(roles, eq(users.roleId, roles.id))
		.where(eq(users.id, userId!))

	return user
})
