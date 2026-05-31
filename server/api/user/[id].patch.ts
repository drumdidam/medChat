import { db } from "../../db";
import { users } from "../../db/schema";
import { eq } from "drizzle-orm";

export default defineEventHandler(async (event) => {
	const session = await getUserSession(event);

	if (!session.user) {
		throw createError({ statusCode: 401, message: "Not authenticated" });
	}

	const userId = session.user.id;
	const { username, email, specialty, verificationDocument, institution, dateOfBirth, homeCountry, firstName, lastName } = await readBody(event);

	await db.update(users).set({
		username, email, specialty, verificationDocument, institution,
		dateOfBirth: dateOfBirth ? new Date(dateOfBirth) : null,
		homeCountry, firstName, lastName,
		updatedAt: new Date(),
	}).where(eq(users.id, userId));
});
