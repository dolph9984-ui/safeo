import { pgTable, uuid, text } from 'drizzle-orm/pg-core';
import { timestamps } from './column-helper';

export const user = pgTable('user', {
  id: uuid('id').defaultRandom().primaryKey(),
  email: text('email').unique().notNull(),
  firstName: text('first_name').notNull(),
  lastName: text('last_name').notNull(),
  password: text('password'),
  ...timestamps,
});

//type
export type User = typeof user.$inferSelect;
