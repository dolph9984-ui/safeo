import { Module } from '@nestjs/common';
import { AppService } from './app.service';
import { AuthModule } from './auth/auth.module';
import { ConfigModule } from '@nestjs/config';
import { DrizzleModule } from './drizzle/drizzle.module';
import { UserModule } from './user/user.module';
import authConfig from './core/configs/oauth.config';
import dbConfig from './core/configs/db.config';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      load: [authConfig, dbConfig],
    }),
    AuthModule,
    DrizzleModule,
    UserModule,
  ],
  providers: [AppService],
})
export class AppModule {}
