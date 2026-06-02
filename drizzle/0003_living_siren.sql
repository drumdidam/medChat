ALTER TABLE "posts" ADD COLUMN "attachments" text[] DEFAULT '{}' NOT NULL;--> statement-breakpoint
ALTER TABLE "users" ADD COLUMN "avatar_url" text;