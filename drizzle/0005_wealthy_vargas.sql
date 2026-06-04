ALTER TABLE "users" ADD COLUMN "is_document_verified" boolean DEFAULT false NOT NULL;--> statement-breakpoint
ALTER TABLE "users" ADD COLUMN "document_verified_at" timestamp;--> statement-breakpoint
ALTER TABLE "users" ADD COLUMN "document_verified_by" uuid;--> statement-breakpoint
ALTER TABLE "users" ADD CONSTRAINT "users_document_verified_by_users_id_fk" FOREIGN KEY ("document_verified_by") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;