import { db } from "../db";
import { posts } from "../db/schema";
import { writeFile } from "fs/promises";
import { join } from "path";

export default defineEventHandler(async (event) => {
	const session = await getUserSession(event);
	if (!session.user) {
		throw createError({ statusCode: 401, message: "Not authenticated" });
	}
	const userId = session.user.id;

	const form = await readFormData(event);
	const content = form.get("content") as string;
	const topicId = form.get("topicId") as string;
	const files = form.getAll("files") as File[];

	const attachments: string[] = [];
	for (const file of files) {
		if (!file.size) continue;
		const ext = file.name.includes(".") ? "." + file.name.split(".").pop() : "";
		const filename = `${crypto.randomUUID()}-${Date.now()}${ext}`;
		const buffer = Buffer.from(await file.arrayBuffer());
		await writeFile(join(process.cwd(), "public", "uploads", filename), buffer);
		attachments.push(`/uploads/${filename}`);
	}

	const [post] = await db
		.insert(posts)
		.values({ content, topicId, userId, attachments })
		.returning();
	return post;
});
