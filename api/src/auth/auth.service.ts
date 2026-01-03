import { Injectable, BadRequestException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import {
  GOOGLE_AUTHORIZE_REQUEST_URL,
  GOOGLE_SCOPES,
} from 'src/constants/oauth.constants';
import { generateRandomString } from 'src/utils/crypto-utils';

@Injectable()
export class AuthService {
  constructor(private configService: ConfigService) {}

  generateGoogleAuthUrl(codeChallenge: string) {
    if (!codeChallenge)
      throw new BadRequestException('Le codeChallenge est requis');

    const params = new URLSearchParams({
      client_id: this.configService.get<string>('oauth.google.clientId')!,
      redirect_uri: this.configService.get<string>('oauth.google.redirectUri')!,
      response_type: 'code',
      scope: GOOGLE_SCOPES.join(' '),
      state: generateRandomString(),
      code_challenge: codeChallenge,
      code_challenge_method: 'S256',
    });

    return `${GOOGLE_AUTHORIZE_REQUEST_URL}?${params.toString()}`;
  }
}
