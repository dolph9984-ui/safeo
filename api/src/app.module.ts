import { Module } from '@nestjs/common';
import { AppService } from './app.service';
import { AuthModule } from './oauth/oauth.module';
import { ConfigModule } from '@nestjs/config';
import authConfig from './configs/oauth.config';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      load: [authConfig],
    }),
    AuthModule,
  ],
  providers: [AppService],
})
export class AppModule {}
