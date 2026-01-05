import { OauthService } from './oauth.service';
import {
  BadRequestException,
  Body,
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Post,
  Query,
  Res,
} from '@nestjs/common';
import { firstValueFrom } from 'rxjs';
import {
  ApiBody,
  ApiCreatedResponse,
  ApiTags,
  ApiBadRequestResponse,
  ApiOkResponse,
  ApiOperation,
} from '@nestjs/swagger';
import express from 'express';
import {
  AuthorizeUrlResponseDto,
  GenerateAuthUrlDto,
} from './dtos/generate-auth-url.dto';
import { BaseApiReturn } from 'src/core/interfaces';
import {
  ExchangeTokenDto,
  ExchangeTokenResponseDto,
} from './dtos/exchange-token.dto';
import { OAUTH_ERROR_MESSAGES } from './constants';
import { renderRedirectionTemplate } from './templates/redirection_fallback_template';
import {
  generateCodeVerifier,
  generateCodeChallenge,
} from 'src/utils/pkce-utils';
import { GeneratePKCECodesDto } from './dtos/generate-pkce-codes.dto';

interface AuthorizeUrlResponse extends BaseApiReturn {
  auth_url: string;
}

interface ExchangeTokenResponse extends BaseApiReturn {
  payload: Record<string, any>;
}

interface PKCEGeneratorResponse {
  codeVerifier: string;
  codeChallenge: string;
}

@ApiTags('0auth')
@Controller('oauth')
export class OauthController {
  constructor(private auhtService: OauthService) {}

  @Get('pkce-generator')
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({
    summary: 'Générer des codes PKCE',
  })
  @ApiCreatedResponse({
    description:
      "Codes PKCE générés pour utiliser dans le processus d'authentification 0Auth",
    type: GeneratePKCECodesDto,
  })
  async generatePKCECodes(): Promise<PKCEGeneratorResponse> {
    const codeVerifier = generateCodeVerifier();

    return {
      codeVerifier: codeVerifier,
      codeChallenge: await generateCodeChallenge(codeVerifier),
    };
  }

  @Post('google/authorize-url')
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({
    summary: "Générer l'URL d'autorisation Google",
  })
  @ApiCreatedResponse({
    description: 'Lien de connexion généré avec succès',
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
      message: 'Lien de connexion généré avec succès',
    };
  }

  @Post('google/exchange-token')
  @ApiOperation({
    summary: "Échanger le code d'autorisation contre un token",
  })
  @ApiBody({ type: ExchangeTokenDto })
  @ApiOkResponse({
    description: 'Token échangé avec succés',
    type: ExchangeTokenResponseDto,
  })
  @ApiBadRequestResponse({
    description:
      "Le code d'autorisation est invalide, expiré ou a déjà été utilisé",
  })
  @HttpCode(HttpStatus.OK)
  async exchangeToken(
    @Body() exchangeTokenDto: ExchangeTokenDto,
  ): Promise<ExchangeTokenResponse> {
    try {
      const responsePayload = await firstValueFrom(
        this.auhtService.exchangeCodeToToken(
          exchangeTokenDto.codeVerifier,
          exchangeTokenDto.authorizationCode,
        ),
      );

      return {
        statusCode: HttpStatus.OK,
        payload: responsePayload,
        message: '',
      };
    } catch (err) {
      console.error('An error was occurend when exchanging token: ', err);

      if (err instanceof BadRequestException) {
        throw err;
      }

      throw new BadRequestException(
        "Le code d'autorisation est invalide, expiré ou a déjà été utilisé. Veuillez recommencer le processus d'authentification.",
      );
    }
  }

  @Get('google/callback')
  @HttpCode(HttpStatus.PERMANENT_REDIRECT)
  @ApiOperation({
    summary: 'Callback de redirection Google OAuth',
  })
  @ApiOkResponse({
    description:
      "Redirection vers l'application mobile avec le code d'autorisation",
  })
  @ApiBadRequestResponse({
    description: "Le code d'authorisation est requis",
  })
  googleAuthCallback(
    @Res() res: express.Response,
    @Query('code') code: string,
    @Query('state') state: string,
    @Query('error') error: string,
  ) {
    if (!code || code.toString().length === 0) {
      throw new BadRequestException("Le code d'authorisation est requis");
    }

    const params = new URLSearchParams();

    if (code) {
      params.append('code', code);
    }

    if (state) {
      params.append('state', state);
    }

    if (error && error.trim().length > 0) {
      const errorMessage =
        OAUTH_ERROR_MESSAGES[error] ||
        "Une erreur s'est produite lors de l'authentification avec Google";

      params.append('error', errorMessage);
    }

    const deepLink = `safeo://auth?${params.toString()}`;

    // close window and redirect to deep link
    return res.send(renderRedirectionTemplate(deepLink));
  }
}
