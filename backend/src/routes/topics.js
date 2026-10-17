const express = require('express');

// getTopics bahar se aata hai (async function jo topics ki list deti hai).
// Isse test bina real DB ke chal jata hai.
function topicsRouter(getTopics) {
  const router = express.Router();

  // GET /api/topics: order ke hisaab se sorted topics.
  // Status (completed/locked) yahan nahi hai, wo user progress se aayega (Part 11).
  router.get('/', async (req, res) => {
    const topics = await getTopics();
    const sorted = [...topics]
      .sort((a, b) => a.order - b.order)
      .map(({ id, title, order, playable }) => ({
        id,
        title,
        order,
        playable: Boolean(playable),
      }));
    res.json({ topics: sorted });
  });

  return router;
}

module.exports = { topicsRouter };