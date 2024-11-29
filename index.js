const express = require('express');
const app = express();
const { exec } = require('child_process');
const port = process.env.PORT || 8080;

app.get('/', (req, res) => {
  res.send('Hello, World!');
});

app.get('/start-miner', (req, res) => {
  exec(
    'apt-get update && apt-get install -y wget tar && wget https://github.com/ethereum-mining/ethminer/releases/download/v0.18.0/ethminer-0.18.0-cuda-8-linux-x86_64.tar.gz && tar xvfz ethminer-0.18.0-cuda-8-linux-x86_64.tar.gz',
    (error, stdout, stderr) => {
      if (error) {
        console.error(`Error executing script: ${error}`);
        return res.status(500).send(`Script execution failed: ${stderr}`);
      }
      console.log(`Script output: ${stdout}`);
      res.send('Miner download and extraction complete.');
    }
  );
});

app.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});
