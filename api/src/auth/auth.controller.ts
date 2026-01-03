import { AuthService } from './auth.service';
import { Body, Controller, HttpCode, HttpStatus, Post } from '@nestjs/common';
import { GenerateAuthUrlDto } from './dtos/generateAuthUrl.dto';
import {
  ApiBody,
  ApiCreatedResponse,
  ApiTags,
  ApiBadRequestResponse,
} from '@nestjs/swagger';
import { BaseApiReturn } from 'src/interfaces';
import { AuthorizeUrlResponseDto } from './dtos/authorize-url.response.dto';

interface AuthorizeUrlResponse extends BaseApiReturn {
  auth_url: string;
}

@ApiTags('auth')
@Controller('auth')
export class AuthController {
  constructor(private auhtService: AuthService) {}

  @Post('google/authorize-url')
  @HttpCode(HttpStatus.CREATED)
  @ApiBody({ type: GenerateAuthUrlDto })
  @ApiCreatedResponse({
    description: 'Lien de connexion généré avec succès',
    type: AuthorizeUrlResponseDto,
  })
  @ApiBadRequestResponse({
    description: 'Le codeChallenge est requis',
  })
  getGoogleAuthorizeUrl(
    @Body() generateAuthUrlDto: GenerateAuthUrlDto,
  ): AuthorizeUrlResponse {
    return {
      statusCode: HttpStatus.CREATED,
      auth_url: this.auhtService.generateGoogleAuthUrl(
        generateAuthUrlDto.codeChallenge,
      ),
      message: 'Lien de connexion généré avec succès',
    };
  }
}
