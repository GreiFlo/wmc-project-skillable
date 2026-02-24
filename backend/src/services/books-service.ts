import { Book } from '../models/book';
import path, { resolve } from 'path';
import fs from 'fs';
import sqlite3 from 'sqlite3';
import { title } from 'process';

export class BooksService {
  private csvFilename = 'csv/books.csv';
  private _books: Book[] = [];
  private db = new sqlite3.Database('skillable.sqlite')

  constructor() {
    this.initializeDb();
  }

  private initializeDb() {
    if (fs.existsSync('skillable.sqlite')) return;

    //DB erstellen und Tabelle
    this.db.serialize(() => {
      //Für jede Tabelle mit this.db.run('CREATE TABLE ...')
      // this.db.run(
      //   'CREATE TABLE IF NOT EXISTS book (id INTEGER PRIMARY KEY, title TEXT, author TEXT, year INTEGER)'
      // );
      this.db.run(
        'CREATE TABLE IF NOT EXISTS user (id INTEGER PRIMARY KEY, username TEXT, email TEXT, passhash TEXT)'
      );

      this.db.run(
        'CREATE TABLE IF NOT EXISTS skill (id INTEGER PRIMARY KEY, user_id INTEGER, title TEXT, description TEXT, FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE)'
      );
    });
  }

  async getAllBooks(): Promise<Book[]> {
    return new Promise((resolve, reject) => {
      this.db.serialize(() => {
        this.db.all('SELECT id, title, author, year FROM book', (err, rows: Book[]) => {
          if (err) {
            reject(err);
            return;
          }

          const books = rows.sort((a, b) => a.title.localeCompare(b.title));
          resolve(books);
        });
      });
    });
  }


  async getBookById(id: number): Promise<Book> {
    return new Promise((resolve, reject) => {
      this.db.serialize(() => {
        this.db.all('SELECT id, title, author, year FROM book', (err, rows: Book[]) => {
          if (err) {
            reject(err);
            return;
          }

          const book = rows.find(x => x.id === id);
          resolve(book!);
        });
      });
    });
  }

  addBook(book: Book): Book {
    const stmt = this.db.prepare('INSERT INTO book (title, author, year) VALUES ($title, $author, $year)');
    stmt.run({$title: book.title, $author: book.author, $year: book.year});
    stmt.finalize();
    return book;
  }

  updateBook(id: number, updatedBook: Book): boolean {
    this.db.run('UPDATE book SET title = $title, author = $author, year = $year WHERE id = $id', {
      $title: updatedBook.title,
      $author: updatedBook.author,
      $year: updatedBook.year,
      $id: id,
    });

    return true;
  }

  deleteBook(id: number): boolean{
    this.db.run('DELETE FROM book WHERE id = $id', { $id: id });
    return true;
  }
}
