import { Module } from '@nestjs/common';
import { AppService } from './app.service';
import { AuthModule } from './oauth/oauth.module';
import { ConfigModule } from '@nestjs/config';
import { DrizzleModule } from './drizzle/drizzle.module';
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
  ],
  providers: [AppService],
})
export class AppModule {}
