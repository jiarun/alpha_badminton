const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
const port = 3320;
app.get('/', (req, res) => {
  res.send('Hello, world!');
});
// MySQL connection
const db = mysql.createConnection({
  host: 'localhost',
  user: 'your-username', // Replace with your MySQL username
  password: 'your-password', // Replace with your MySQL password
  database: 'your-database' // Replace with your MySQL database name
});

db.connect((err) => {
  if (err) {
    console.error('Error connecting to MySQL:', err);
    return;
  }
  console.log('Connected to MySQL');
});

// Middleware
app.use(cors());
app.use(bodyParser.json({ limit: '50mb' }));

// Registration endpoint
app.post('/register', (req, res) => {
  const { mobile, password } = req.body;
  const query = 'INSERT INTO users (mobile, password) VALUES (?, ?)';
  db.query(query, [mobile, password], (err, result) => {
    if (err) {
      console.error('Error registering user:', err);
      return res.status(500).json({ success: false });
    }
    res.json({ success: true, user: { id: result.insertId, mobile: mobile } });
  });
});

// Login endpoint
app.post('/login', (req, res) => {
  const { mobile } = req.body;
  const query = 'SELECT * FROM users WHERE mobile = ?';
  db.query(query, [mobile], (err, results) => {
    if (err) {
      console.error('Error logging in:', err);
      return res.status(500).json({ success: false });
    }
    if (results.length > 0) {
      res.json({ success: true, user: results[0] });
    } else {
      res.json({ success: false });
    }
  });
});

// Forgot password endpoint
app.post('/forgot-password', (req, res) => {
  const { mobile } = req.body;
  const query = 'SELECT * FROM users WHERE mobile = ?';
  db.query(query, [mobile], (err, results) => {
    if (err) {
      console.error('Error forgot password:', err);
      return res.status(500).json({ success: false });
    }
    if (results.length > 0) {
      // Here you would typically send a password reset email or SMS
      console.log('Password reset request for:', results[0].mobile);
      res.json({ success: true });
    } else {
      res.json({ success: false });
    }
  });
});

app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});
