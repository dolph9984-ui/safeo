import { HttpService } from '@nestjs/axios';
import { Injectable, BadRequestException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { AxiosResponse } from 'axios';
import {
  GOOGLE_AUTHORIZE_REQUEST_URL,
  GOOGLE_SCOPES,
  GOOGLE_TOKEN_REQUEST_URL,
} from 'src/constants/oauth.constants';
import { IExchangeCodeToTokenResponse } from 'src/interfaces';
import { generateRandomString } from 'src/utils/crypto-utils';

@Injectable()
export class OauthService {
  constructor(
    private configService: ConfigService,
    private httpService: HttpService,
  ) {}

  generateGoogleAuthUrl(codeChallenge: string): string {
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

  exchangeCodeToToken(
    code_verifier: string,
    code: string,
  ): Observable<IExchangeCodeToTokenResponse> {
    if (!code_verifier || !code)
      throw new BadRequestException('Le code et code_verifier est requis');

    return this.httpService
      .post<IExchangeCodeToTokenResponse>(
        GOOGLE_TOKEN_REQUEST_URL,
        new URLSearchParams({
          client_id: this.configService.get<string>('oauth.google.clientId')!,
          client_secret: this.configService.get<string>(
            'oauth.google.clientSecret',
          )!,
          code_verifier,
          code,
          grant_type: 'authorization_code',
          redirect_uri: this.configService.get<string>(
            'oauth.google.redirectUri',
          )!,
        }).toString(),
        {
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        },
      )
      .pipe(
        map(
          (response: AxiosResponse<IExchangeCodeToTokenResponse>) =>
            response.data,
        ),
      );
  }
}
