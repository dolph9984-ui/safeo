import { Module } from '@nestjs/common';
import { OauthController } from './oauth.controller';
import { OauthService } from './oauth.service';
import { HttpModule } from '@nestjs/axios';

@Module({
  controllers: [OauthController],
  providers: [OauthService],
  imports: [HttpModule],
})
export class AuthModule {}
