import { ConfigService } from '@nestjs/config';
import { drizzle, NodePgDatabase } from 'drizzle-orm/node-postgres';
import { Pool } from 'pg';
import { user } from './schemas/user.schema';

const schema = {
  ...user,
};

export const drizzleProvider = [
  {
    provide: 'DrizzleAsyncProvider',
    inject: [ConfigService],
    useFactory: (configService: ConfigService) => {
      const connectionUrl = configService.get<string>('database.url');
      const pool = new Pool({
        connectionString: connectionUrl,
      });

      return drizzle(pool, { schema }) as NodePgDatabase<typeof schema>;
    },
  },
];
