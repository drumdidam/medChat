import { createReadStream } from "fs";
import { stat } from "fs/promises";
import { join, resolve, sep } from "path";

// Mirrors the write target in server/api/user/avatar.post.ts:
//   writeFile(join(process.cwd(), "public", "uploads", filename), ...)
const UPLOADS_DIR = join(process.cwd(), "public", "uploads");

export default defineEventHandler(async (event) => {
  const path = getRouterParam(event, "path");

  if (!path) {
    throw createError({ statusCode: 404, message: "File not found" });
  }

  // Resolve the requested path against the uploads dir, then verify the
  // result still lives inside it. This neutralises path traversal such as
  // "../../../etc/passwd" or absolute paths, regardless of OS separator.
  const filepath = resolve(UPLOADS_DIR, path);
  if (filepath !== UPLOADS_DIR && !filepath.startsWith(UPLOADS_DIR + sep)) {
    throw createError({ statusCode: 403, message: "Forbidden" });
  }

  let stats;
  try {
    stats = await stat(filepath);
  } catch {
    throw createError({ statusCode: 404, message: "File not found" });
  }

  if (!stats.isFile()) {
    throw createError({ statusCode: 404, message: "File not found" });
  }

  setHeader(event, "Content-Type", contentTypeFor(filepath));
  setHeader(event, "Content-Length", stats.size);
  setHeader(event, "Cache-Control", "public, max-age=31536000, immutable");

  return sendStream(event, createReadStream(filepath));
});
