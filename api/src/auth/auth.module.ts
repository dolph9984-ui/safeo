import { Module } from '@nestjs/common';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { HttpModule } from '@nestjs/axios';
import { DrizzleModule } from 'src/drizzle/drizzle.module';
import { JwtModule } from '@nestjs/jwt';
import { UserModule } from 'src/user/user.module';
import { ConfigModule } from '@nestjs/config';
import { JWT_SECRET } from './constants';

@Module({
  controllers: [AuthController],
  providers: [AuthService],
  imports: [
    HttpModule,
    DrizzleModule,
    ConfigModule,
    JwtModule.register({
      global: true,
      secret: JWT_SECRET,
      signOptions: { expiresIn: '1d' },
    }),
    UserModule,
  ],
})
export class AuthModule {}
