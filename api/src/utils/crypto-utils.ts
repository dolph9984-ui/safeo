import { randomBytes } from 'crypto';

export const generateRandomString = (length: number = 128) => {
  return randomBytes(length).toString('hex');
};
