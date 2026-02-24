import express, { Request, Response } from 'express';
import bodyParser from 'body-parser';
import 'dotenv/config';
import cors from 'cors';

import { BooksService } from './services/books-service';

const booksService = new BooksService();

const app = express();
app.use(cors());
app.use(bodyParser.json()); // wichtig damit man in Request dann mit req.body gleich ein JSON bekommt

const port = process.env.PORT || 3000; // wenn PORT false undefind ist dann nimmt er den anderen

app.get('/books/:id', async (req: Request, res: Response) => {
  if (!req.params.id) {
    return res.send(await booksService.getAllBooks());
  }
  const book = await booksService.getBookById(+req.params.id);
  if (!book) {
    return res.status(404).send({ error: 'Book not found' });
  }
  res.send(book);
});

app.post('/books', (req: Request, res: Response) => {
  res.status(200).send(booksService.addBook(req.body));
});

app.put('/books/:id', (req: Request, res: Response) => {
  if (!req.params.id) {
    return res.status(400).send({ error: 'Missing id parameter' });
  }
  const success = booksService.updateBook(+req.params.id!, req.body);
  if (!success) {
    return res.status(400).send({ error: 'Failed to update book' });
  }
  res.status(200).send({ message: 'Book updated successfully' });
});

app.delete('/books', (req: Request, res: Response) => {
  if (!req.query.id) {
    return res.status(400).send({ error: 'Missing id parameter' });
  }
  const success = booksService.deleteBook(+req.query.id!);
  if (!success) {
    return res.status(400).send({ error: 'Failed to delete book' });
  }
  res.status(200).send({ message: 'Book deleted successfully' });
});

app.listen(port, () => {
  console.log(`server started on port ${port}`);
});
