const { createApp } = require('./app');

const PORT = process.env.PORT || 3000;

createApp().listen(PORT, () => {
  console.log(`ABHAY backend chal raha hai: http://localhost:${PORT}`);
});