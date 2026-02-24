import { NextFunction, Response } from "express";
import { AuthRequest } from "../models/auth/authrequest";
import jwt, { JwtPayload } from 'jsonwebtoken';


export function authMiddleware(req: AuthRequest, res: Response, next: NextFunction): void {
  const token = req.headers['authorization']?.split(' ')[1];
  if (!token) {
    res.status(401).json({ error: 'No Token' });
    return;
  }

  jwt.verify(token, process.env.JWT_SECRETE ?? "", (err, decoded) => {
    if (err) {
      res.status(403).json({ error: 'Token invalid!' });
      return;
    }
    req.user = decoded as JwtPayload;
    next();
  });
}