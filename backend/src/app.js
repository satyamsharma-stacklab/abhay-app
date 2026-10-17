const express = require('express');

// Express app banata hai. Server start yahan nahi hota (test ke liye).
function createApp() {
  const app = express();
  app.use(express.json());

  // Health check: server zinda hai ya nahi.
  app.get('/health', (req, res) => {
    res.json({ status: 'ok', service: 'abhay-backend' });
  });

  // Jo route nahi mila uska saaf jawab.
  app.use((req, res) => {
    res.status(404).json({ error: 'Route nahi mila' });
  });

  // Koi bhi error aaye to server crash na ho.
  // eslint-disable-next-line no-unused-vars
  app.use((err, req, res, next) => {
    console.error(err);
    res.status(500).json({ error: 'Server mein kuch gadbad hui' });
  });

  return app;
}

module.exports = { createApp };