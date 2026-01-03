import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString } from 'class-validator';

export class GenerateAuthUrlDto {
  @ApiProperty({ example: '' })
  @IsString()
  @IsNotEmpty()
  codeChallenge: string;
}
