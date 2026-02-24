import { Request } from 'express';
import jwt, { JwtPayload } from 'jsonwebtoken';

export interface AuthRequest extends Request {
  user?: JwtPayload;
};