import express, { Response } from 'express';
import { AuthRequest } from '../models/auth/authrequest';
import { authMiddleware } from '../middlewares/authmiddleware';
import { DbService } from '../services/db-service';
import { Message } from '../models/message';
require('dotenv').config();

const router = express.Router();

const db = DbService.getDb();



module.exports = router;