import { pgTable, text, timestamp, uuid, boolean, jsonb, type AnyPGColumn } from "drizzle-orm/pg-core";

export const roles = pgTable("roles", {
  id: uuid("id").primaryKey().defaultRandom(),
  name: text("name").notNull().unique(),
  permissions: jsonb("permissions").notNull().default({}),
});

export const users = pgTable("users", {
  id: uuid("id").primaryKey().defaultRandom(),
  username: text("username").notNull().unique(),
  email: text("email").notNull().unique(),
  password: text("password").notNull(),
  roleId: uuid("role_id").references(() => roles.id),
  isVerified: boolean("is_verified").notNull().default(false),
  verificationDocument: text("verification_document"),
  specialty: text("specialty"),
  firstName: text("first_name"),
  lastName: text("last_name"),
  dateOfBirth: timestamp("date_of_birth"),
  homeCountry: text("home_country"),
  institution: text("institution"),
  avatarUrl: text("avatar_url"),
  verifyToken: text("verify_token"),
  verifyTokenExpiry: timestamp("verify_token_expiry"),
  isDocumentVerified: boolean("is_document_verified").notNull().default(false),
  documentVerifiedAt: timestamp("document_verified_at"),
  documentVerifiedBy: uuid("document_verified_by").references((): AnyPGColumn => users.id),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull(),
});

export const categories = pgTable("categories", {
  id: uuid("id").primaryKey().defaultRandom(),
  name: text("name").notNull().unique(),
  description: text("description"),
});

export const topics = pgTable("topics", {
  id: uuid("id").primaryKey().defaultRandom(),
  title: text("title").notNull(),
  description: text("description"),
  userId: uuid("user_id").references(() => users.id, { onDelete: 'set null' }),
  categoryId: uuid("category_id").references(() => categories.id),
  isResolved: boolean("is_resolved").notNull().default(false),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull(),
});

export const posts = pgTable("posts", {
  id: uuid("id").primaryKey().defaultRandom(),
  content: text("content").notNull(),
  userId: uuid("user_id").references(() => users.id, { onDelete: 'set null' }),
  topicId: uuid("topic_id").notNull().references(() => topics.id),
  attachments: text("attachments").array().default([]).notNull(),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull(),
});
