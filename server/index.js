// server/index.js
require('dotenv').config(); // 👈 Add this at the very top!

const app = require('./app');
const port = process.env.PORT || 3000;

app.listen(port, () => {
  console.log(`Server Listening on Port http://localhost:${port}`);
});
