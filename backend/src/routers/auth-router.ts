import express, { Request, Response, NextFunction } from 'express';
import { User } from '../models/user';
import argon2 from 'argon2';
import jwt, { JwtPayload } from 'jsonwebtoken';
import { AuthRequest } from '../models/auth/authrequest';
import { authMiddleware } from '../middlewares/authmiddleware';
import { DbService } from '../services/db-service';
require('dotenv').config();

const router = express.Router();

const db = DbService.getDb();

router.post('/register', async (req: Request, res: Response): Promise<void> => {
  const { username, email, password } = req.body as {
    username?: string;
    email?: string;
    password?: string;
  };

  if (!username?.trim() || !email?.trim() || !password?.trim()) {
    res.status(400).json({ error: 'Username, Email und Passwort erforderlich' });
    return;
  }

  console.log(db)

  db.get<User>(
    'SELECT id FROM users WHERE username = ? OR email = ?',
    [username, email],
    async (err, row) => {
      if (err) { res.status(500).json({ error: err.message }); return; }
      if (row) { res.status(409).json({ error: 'Username oder Email bereits vergeben' }); return; }

      try {
        const passhash = await argon2.hash(password);

        db.run(
          'INSERT INTO users (username, email, passhash) VALUES (?, ?, ?)',
          [username.trim(), email.trim(), passhash],
          function (err) {
            if (err) { res.status(500).json({ error: err.message }); return; }

            db.get<User>(
              'SELECT id, username, email, created_at FROM users WHERE id = ?',
              [this.lastID],
              (err, user) => {
                if (err) { res.status(500).json({ error: err.message }); return; }
                const token = jwt.sign({ id: user.id, username: user.username }, process.env.JWT_SECRETE!, { expiresIn: '7d' });
                res.status(201).json({ token, user });
              }
            );
          }
        );
      } catch (err: any) {
        res.status(500).json({ error: err.message });
      }
    }
  );
});

router.post('/login', async (req: Request, res: Response): Promise<void> => {
  const { email, password } = req.body as { email?: string; password?: string };

  if (!email?.trim() || !password?.trim()) {
    res.status(400).json({ error: 'Email und Passwort erforderlich' });
    return;
  }

  db.get<User>('SELECT * FROM users WHERE email = ?', [email.trim()], async (err, user) => {
    if (err) { res.status(500).json({ error: err.message }); return; }
    if (!user) { res.status(401).json({ error: 'Email oder Passwort falsch' }); return; }

    try {
      const valid = await argon2.verify(user.passhash!, password);
      if (!valid) { res.status(401).json({ error: 'Email oder Passwort falsch' }); return; }

      const token = jwt.sign({ id: user.id, username: user.username }, process.env.JWT_SECRETE!, { expiresIn: '7d' });
      const { passhash, ...safeUser } = user;
      res.json({ token, user: safeUser });
    } catch (err: any) {
      res.status(500).json({ error: err.message });
    }
  });
});

router.get('/users', authMiddleware, (req: AuthRequest, res: Response): void => {
  db.all<User>(
    'SELECT id, username FROM users WHERE id != ?',
    [req.user!.id],
    (err, rows) => {
      if (err) { res.status(500).json({ error: err.message }); return; }
      res.json(rows);
    }
  );
});

module.exports = router;