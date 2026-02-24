import { JwtPayload } from "jsonwebtoken";
import { Socket } from "socket.io";

export interface AuthSocket extends Socket {
  user?: JwtPayload;
};