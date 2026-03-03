import fs from 'fs';
import sqlite3, { Database } from 'sqlite3';

export class DbService {

  static db: Database ;

  public static getDb() : Database {
    if (fs.existsSync('skillable.sqlite') && this.db !== undefined) return this.db;

    this.db = new sqlite3.Database('skillable.sqlite');

    //DB erstellen und Tabelle
    this.db.serialize(() => {
      this.db!.run(
        'PRAGMA foreign_keys = ON'
      );

      this.db!.run(
        'CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT UNIQUE NOT NULL, email TEXT UNIQUE NOT NULL, created_at DATETIME DEFAULT CURRENT_TIMESTAMP, passhash TEXT)'
      );

      this.db!.run(
        'CREATE TABLE IF NOT EXISTS skills (id INTEGER PRIMARY KEY AUTOINCREMENT, user_id INTEGER, title TEXT, description TEXT, creationDate DATETIME DEFAULT CURRENT_TIMESTAMP, longitude REAL, latitude REAL, FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE)'
      );

      this.db!.run(
        `
          CREATE TABLE IF NOT EXISTS messages (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            sender_id INTEGER NOT NULL,
            receiver_id INTEGER NOT NULL,
            content TEXT NOT NULL,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (sender_id) REFERENCES users(id),
            FOREIGN KEY (receiver_id) REFERENCES users(id)
          )
        `
      );
    });

    return this.db;
  }
}
