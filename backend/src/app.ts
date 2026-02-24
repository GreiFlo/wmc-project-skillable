import express from 'express';
import http from 'http';
import { Server } from 'socket.io';
import cors from 'cors';
import jwt, { JwtPayload } from 'jsonwebtoken';
import { DbService } from './services/db-service';
import { Message } from './models/message';
import { AuthSocket } from './models/auth/authsocket';

require('dotenv').config();

const app = express();
const server = http.createServer(app);
const io = new Server(server, { cors: { origin: '*' } });

app.use(cors());
app.use(express.json());

const db = DbService.getDb();

const authRouter = require('./routers/auth-router');
const chatRouter = require('./routers/chat-router');

app.use('/auth', authRouter);
app.use('/chat', chatRouter);

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