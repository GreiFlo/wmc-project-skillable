import express, { Request, Response } from 'express';
import { AuthRequest } from '../models/auth/authrequest';
import { authMiddleware } from '../middlewares/authmiddleware';
import { DbService } from '../services/db-service';
import { Skill } from '../models/skill';
import { AddSkill } from '../models/addSkill';
import jwt from 'jsonwebtoken';
import { JwtPayload } from '../models/auth/jwtpayload';

require('dotenv').config();

const router = express.Router();

const db = DbService.getDb();

router.get('/nearby', authMiddleware, (req: Request, res: Response) => {
  if (req.query.long === undefined || req.query.lat === undefined) {
    res.status(400).json({ error: "Keine Parameter (long, lat) gefunden!" })
    return;
  }

  let long = parseFloat(req.query.long as string);
  let lat = parseFloat(req.query.lat as string);

  db.all<Skill>(`
        SELECT s.id, s.user_id, s.title, s.description, s.creationDate, s.longitude, s.latitude, u.username
        FROM skills s
        JOIN users u ON s.user_id = u.id
        ORDER BY creationDate ASC
        LIMIT 30
      `, (err, rows) => {
    if (err) { res.status(500).json({ error: err.message }); return; }
    res.json(rows.filter(x => getDistanceInKm(x.latitude, x.longitude, lat, long) <= 20));
  });
});

router.get('/all', authMiddleware, (req: Request, res: Response) => {
  console.log('aklsjdfölkasjdfö');
  db.all<Skill>(`
        SELECT s.id, s.user_id, s.title, s.description, s.creationDate, s.longitude, s.latitude, u.username
        FROM skills s
        JOIN users u ON s.user_id = u.id
        ORDER BY creationDate ASC
        LIMIT 30
      `, (err, rows) => {
    if (err) { res.status(500).json({ error: err.message }); return; }
    res.json(rows);
  });
});

router.post('/', authMiddleware, (req: Request, res: Response) => {

  if (req.body === undefined) {
    res.status(400).send();
    return;
  }
  let skill = req.body as AddSkill;

  const token = req.headers['authorization']?.split(' ')[1];

  const user: JwtPayload = jwt.decode(token!) as JwtPayload;

  db.run(
    'INSERT INTO skills (title, description, user_id, longitude, latitude) VALUES (?, ?, ?, ?, ?)',
    [skill.title, skill.description, user.id, skill.long, skill.lat],
    function (err) {
      if (err) { res.status(500).json({ error: err.message }); return; }
      else res.status(200).send();
    },
  );
});

function getDistanceInKm(
  lat1: number,
  lon1: number,
  lat2: number,
  lon2: number
): number {
  const R = 6371;

  const toRad = (value: number): number => (value * Math.PI) / 180;

  const dLat = toRad(lat2 - lat1);
  const dLon = toRad(lon2 - lon1);

  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) * Math.sin(dLon / 2) * Math.sin(dLon / 2);

  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

  return R * c;
}

module.exports = router;