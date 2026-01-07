import { Inject, Injectable, NotFoundException } from '@nestjs/common';
import { eq } from 'drizzle-orm';
import * as drizzleProvider from 'src/drizzle/drizzle.provider';
import { Account, account, User, users } from 'src/drizzle/schemas';
import { AuthTypeEnum } from 'src/enums/auth_enums';

type CreateUserSchema = {
  email: string;
  fullName: string;
  type: string;
  provider: string;
  accessToken: string;
  expiresAt: string;
  scope: string;
  idToken: string;
  tokenType: string;
  sessionState: string;
  providerAccountId: string;
};

type UpdateAccountSchema = Pick<
  CreateUserSchema,
  | 'accessToken'
  | 'expiresAt'
  | 'tokenType'
  | 'scope'
  | 'idToken'
  | 'sessionState'
>;

@Injectable()
export class UserService {
  constructor(
    @Inject('DrizzleAsyncProvider')
    private readonly db: drizzleProvider.DrizzleDB,
  ) {}

  async getUserById(id: string): Promise<User | null> {
    const user = await this.db.query.users.findFirst({
      where: eq(users.id, id),
    });

    return user ?? null;
  }

  async getUserByEmail(email: string): Promise<User | null> {
    const user = await this.db.query.users.findFirst({
      where: eq(users.email, email),
    });

    return user ?? null;
  }

  async createUser(
    userData: CreateUserSchema,
    authType: AuthTypeEnum,
  ): Promise<User[] | undefined> {
    if (authType === AuthTypeEnum.CREDENTIAL) {
      return await this.db.insert(users).values(userData).returning();
    } else {
      await this.db.transaction(async (tx) => {
        const user = await tx.insert(users).values(userData).returning();

        await tx
          .insert(account)
          .values({
            userId: user[0].id,
            type: userData.type,
            provider: userData.provider,
            accessToken: userData.accessToken,
            tokenType: 'Bearer',
            expiresAt: userData.expiresAt,
            scope: userData.scope,
            idToken: userData.idToken,
            sessionState: userData.sessionState,
            providerAccountId: userData.providerAccountId,
          })
          .returning();

        return user;
      });
    }
  }

  async updateAccount(
    userId: string,
    accountData: UpdateAccountSchema,
  ): Promise<Account[]> {
    const user = await this.getUserById(userId);

    if (!user)
      throw new NotFoundException('Aucun utilisateur trouvé avec cet ID.');

    return await this.db
      .update(account)
      .set({ ...accountData })
      .where(eq(account.userId, user?.id))
      .returning();
  }
}
