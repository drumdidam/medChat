import { extname } from "path";

// Maps file extensions to Content-Type headers for files served from disk
// (public/uploads/ and private/documents/). Auto-imported by Nitro.
const CONTENT_TYPES: Record<string, string> = {
  ".png": "image/png",
  ".jpg": "image/jpeg",
  ".jpeg": "image/jpeg",
  ".gif": "image/gif",
  ".webp": "image/webp",
  ".svg": "image/svg+xml",
  ".avif": "image/avif",
  ".pdf": "application/pdf",
};

export function contentTypeFor(filename: string): string {
  const ext = extname(filename).toLowerCase();
  return CONTENT_TYPES[ext] ?? "application/octet-stream";
}
