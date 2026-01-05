import { HttpStatus } from '@nestjs/common';

export interface BaseApiReturn {
  statusCode: HttpStatus;
  message: string;
}

export interface IExchangeCodeToTokenResponse {
  access_token: string;
  id_token: string;
  refresh_token: string;
  refresh_token_expires_in: number;
  scope: string[];
  token_type: string;
}
