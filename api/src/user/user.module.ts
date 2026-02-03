import { Module } from '@nestjs/common';
import { UserService } from './user.service';
import { DrizzleModule } from 'src/drizzle/drizzle.module';

@Module({
  providers: [UserService],
  imports: [DrizzleModule],
  exports: [UserService],
})
export class UserModule {}
