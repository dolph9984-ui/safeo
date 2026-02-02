// URL for authorization request (GOOGLE)
export const GOOGLE_AUTHORIZE_REQUEST_URL =
  'https://accounts.google.com/o/oauth2/v2/auth' as const;

// URL for token request (GOOGLE)
export const GOOGLE_TOKEN_REQUEST_URL =
  'https://oauth2.googleapis.com/token' as const;

export const GOOGLE_SCOPES: string[] = [
  'openid',
  'https://www.googleapis.com/auth/userinfo.email',
  'https://www.googleapis.com/auth/userinfo.profile',
] as const;

export const GOOGLE_USERINFO_REQUEST_URL =
  'https://www.googleapis.com/oauth2/v3/userinfo' as const;
