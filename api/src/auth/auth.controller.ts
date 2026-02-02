import { AuthService } from './auth.service';
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
  UnauthorizedException,
} from '@nestjs/common';
import { firstValueFrom } from 'rxjs';
import { JwtService } from '@nestjs/jwt';
import {
  ApiBody,
  ApiCreatedResponse,
  ApiTags,
  ApiBadRequestResponse,
  ApiOkResponse,
  ApiOperation,
} from '@nestjs/swagger';
import express from 'express';
import { UserService } from 'src/user/user.service';
import { AuthTypeEnum } from 'src/core/enums/auth_enums';
import { BaseApiReturn, IUserFromTokenResponse } from 'src/core/interfaces';
import {
  AuthorizeUrlResponseDto,
  GenerateAuthUrlDto,
} from './dtos/generate-auth-url.dto';
import {
  ExchangeTokenDto,
  ExchangeTokenResponseDto,
} from './dtos/exchange-token.dto';
import { OAUTH_ERROR_MESSAGES } from './constants';
import { renderRedirectionTemplate } from './templates/redirection_fallback_template';
import {
  generateCodeVerifier,
  generateCodeChallenge,
} from 'src/core/utils/pkce-utils';
import { GeneratePKCECodesDto } from './dtos/generate-pkce-codes.dto';

interface AuthorizeUrlResponse extends BaseApiReturn {
  authUrl: string;
}

interface ExchangeTokenResponse extends BaseApiReturn {
  accessToken: string;
}

type PKCEGeneratorResponse = {
  codeVerifier: string;
  codeChallenge: string;
};

@ApiTags('Auth')
@Controller('auth')
export class AuthController {
  constructor(
    private auhtService: AuthService,
    private userService: UserService,
    private jwtService: JwtService,
  ) {}

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
      authUrl: this.auhtService.generateGoogleAuthUrl(
        generateAuthUrlDto.codeChallenge,
      ),
      message: 'Lien de connexion généré avec succès',
    };
  }

  @Post('google/exchange-token')
  @ApiOperation({
    summary:
      "Échanger le code d'autorisation contre un token et insérer l'utilisateur dans la base de données",
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
      // exchange code to token
      const responsePayload = await firstValueFrom(
        this.auhtService.exchangeCodeToToken(
          exchangeTokenDto.codeVerifier,
          exchangeTokenDto.authorizationCode,
        ),
      );

      const userInfoPayload = await firstValueFrom(
        this.auhtService.getUserFromToken(responsePayload.access_token),
      );

      if (!userInfoPayload) throw new BadRequestException();

      const user = await this.userService.getUserByEmail(
        (userInfoPayload as IUserFromTokenResponse).email,
      );

      // create user if not exist and create account
      if (!user) {
        const newUser = await this.userService.createUser(
          {
            email: (userInfoPayload as IUserFromTokenResponse).email,
            fullName: (userInfoPayload as IUserFromTokenResponse).name,
            type: '0Auth',
            provider: 'GOOGLE',
            accessToken: responsePayload.access_token,
            tokenType: 'Bearer',
            expiresAt: responsePayload.expires_in,
            scope: responsePayload.scope,
            idToken: responsePayload.id_token,
            sessionState: '',
            providerAccountId: (userInfoPayload as IUserFromTokenResponse).sub,
          },
          AuthTypeEnum.OAUTH,
        );

        if (newUser?.length === 0 || !newUser) throw new BadRequestException();

        const JWTpayload = { sub: newUser[0].id, email: newUser[0].email };

        return {
          statusCode: HttpStatus.OK,
          accessToken: await this.jwtService.signAsync(JWTpayload),
          message: 'Utilisateur connecté avec succés avec Google',
        };
      }

      //  update account and create JWT Token
      await this.userService.updateAccount(user.id, {
        accessToken: responsePayload.access_token,
        tokenType: 'Bearer',
        expiresAt: responsePayload.expires_in,
        scope: responsePayload.scope,
        idToken: responsePayload.id_token,
        sessionState: '',
      });

      const JWTpayload = { sub: user.id, email: user.email };

      return {
        statusCode: HttpStatus.OK,
        accessToken: await this.jwtService.signAsync(JWTpayload),
        message: 'Utilisateur connecté avec succés avec Google',
      };
    } catch (err) {
      console.error('An error was occurend when exchanging token: ', err);

      if (err instanceof UnauthorizedException) {
        throw err;
      }

      throw new BadRequestException(
        'Impossible d’échanger le code d’autorisation avec Google',
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
