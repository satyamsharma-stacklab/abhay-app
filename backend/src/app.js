const express = require('express');
const { topicsRouter } = require('./routes/topics');

// Express app banata hai. Server start yahan nahi hota (test ke liye).
// getTopics optional hai: diya gaya to /api/topics chalu ho jata hai.
function createApp({ getTopics } = {}) {
  const app = express();
  app.use(express.json());

  // Health check: server zinda hai ya nahi.
  app.get('/health', (req, res) => {
    res.json({ status: 'ok', service: 'abhay-backend' });
  });

  // Topics API (404 handler se pehle jodna zaroori hai).
  if (getTopics) {
    app.use('/api/topics', topicsRouter(getTopics));
  }

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