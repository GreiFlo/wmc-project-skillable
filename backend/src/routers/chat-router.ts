import express, { Response } from 'express';
import { AuthRequest } from '../models/auth/authrequest';
import { authMiddleware } from '../middlewares/authmiddleware';
import { DbService } from '../services/db-service';
import { Message } from '../models/message';
require('dotenv').config();

const router = express.Router();

const db = DbService.getDb();

router.get('/messages', authMiddleware, (req: AuthRequest, res: Response): void => {
  const { user2 } = req.query as { user2?: string };
  const user1 = req.user!.id;

  if (!user2) {
    res.status(400).json({ error: 'user2 benötigt' });
    return;
  }

  db.all<Message>(`
    SELECT m.id, m.content, m.created_at,
           s.username AS sender, r.username AS receiver,
           m.sender_id, m.receiver_id
    FROM messages m
    JOIN users s ON m.sender_id = s.id
    JOIN users r ON m.receiver_id = r.id
    WHERE (m.sender_id = ? AND m.receiver_id = ?)
       OR (m.sender_id = ? AND m.receiver_id = ?)
    ORDER BY m.created_at ASC
    LIMIT 100
  `, [user1, user2, user2, user1], (err, rows) => {
    if (err) { res.status(500).json({ error: err.message }); return; }
    res.json(rows);
  });
});

module.exports = router;