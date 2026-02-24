import express, { Request, Response, NextFunction } from 'express';
import http from 'http';
import { Server, Socket } from 'socket.io';
import cors from 'cors';
import jwt, { JwtPayload } from 'jsonwebtoken';
import { DbService } from './services/db-service';
import { Message } from './models/message';
import { AuthRequest } from './models/auth/authrequest';
import { AuthSocket } from './models/auth/authsocket';
import { authMiddleware } from './middlewares/authmiddleware';

require('dotenv').config();

const app = express();
const server = http.createServer(app);
const io = new Server(server, { cors: { origin: '*' } });

app.use(cors());
app.use(express.json());

const db = DbService.getDb();

const authRouter = require('./routers/auth-router');

app.use('/auth', authRouter);

app.get('/messages', authMiddleware, (req: AuthRequest, res: Response): void => {
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

const onlineUsers = new Map<number, string>();

io.use((socket: AuthSocket, next) => {
  const token = socket.handshake.auth?.token as string | undefined
    ?? socket.handshake.headers['auth.token'] as string | undefined;

  if (!token) return next(new Error('Kein Token'));

  jwt.verify(token, process.env.JWT_SECRETE!, (err, decoded) => {
    if (err) return next(new Error('Token ungültig'));
    socket.user = decoded as JwtPayload;
    next();
  });
});

io.on('connection', (socket: AuthSocket) => {
  console.log(`${socket.user!.username} verbunden`);
  onlineUsers.set(socket.user!.id, socket.id);

  socket.on('send_message', ({ receiverId, content }: { receiverId: number; content: string }) => {
    if (!content?.trim()) return;

    const senderId = socket.user!.id;

    db.run(
      'INSERT INTO messages (sender_id, receiver_id, content) VALUES (?, ?, ?)',
      [senderId, receiverId, content.trim()],
      function (err) {
        if (err) { socket.emit('error', { message: err.message }); return; }

        const message: Message = {
          id: this.lastID,
          sender_id: senderId,
          receiver_id: receiverId,
          content: content.trim(),
          created_at: new Date().toISOString()
        };

        const receiverSocketId = onlineUsers.get(receiverId);
        if (receiverSocketId) {
          io.to(receiverSocketId).emit('receive_message', message);
        }

        socket.emit('message_sent', message);
      }
    );
  });

  socket.on('disconnect', () => {
    console.log(`${socket.user!.username} getrennt`);
    onlineUsers.delete(socket.user!.id);
  });
});

server.listen(3000, () => console.log('Server läuft auf Port 3000'));