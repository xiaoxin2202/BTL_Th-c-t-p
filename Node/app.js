export express from 'express';

const app = express();

app.get('/', (req, res)=> {
  res.status(200).send('hello');
});

app.listent(3000, () => {
  console.log('server is nrrning');
})
