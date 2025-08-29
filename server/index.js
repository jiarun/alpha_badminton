const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
const port = 3000;
app.get('/', (req, res) => {
  res.send('Hello, world!');
});
// MySQL connection


const pool = mysql.createPool({
  connectionLimit: 10, // adjust as needed
  host: '184.168.113.105',
    user: 'test1', // Replace with your MySQL username
    password: 'mo)lC%oRIhTR', // Replace with your MySQL password
    database: 'test_alpha' // Replace with your MySQL database name
});

/*
const db = mysql.createConnection({
  host: '184.168.113.105',
  user: 'test1', // Replace with your MySQL username
  password: 'mo)lC%oRIhTR', // Replace with your MySQL password
  database: 'test_alpha' // Replace with your MySQL database name
});
*/

// Test the connection pool and create tables if they don't exist
pool.getConnection((err, connection) => {
  if (err) {
    console.error('Error connecting to MySQL:', err);
    return;
  }
  console.log('Connected to MySQL');

  // Alter users table to add profile_picture and name fields if they don't exist
  const alterUsersTable = `
    ALTER TABLE users 
    ADD COLUMN IF NOT EXISTS profile_picture VARCHAR(255) NULL,
    ADD COLUMN IF NOT EXISTS name VARCHAR(255) NULL
  `;

  connection.query(alterUsersTable, (err) => {
    if (err) {
      console.error('Error altering users table:', err);
    } else {
      console.log('Users table updated');
    }

    // Alter matches table to add opponent_id and opponent_name fields if they don't exist
    const alterMatchesTable = `
      ALTER TABLE matches 
      ADD COLUMN IF NOT EXISTS opponent_id INT NULL,
      ADD COLUMN IF NOT EXISTS opponent_name VARCHAR(255) NULL
    `;

    connection.query(alterMatchesTable, (err) => {
      if (err) {
        console.error('Error altering matches table:', err);
      } else {
        console.log('Matches table updated with opponent fields');
      }

      // Create matches table if it doesn't exist
      const createMatchesTable = `
        CREATE TABLE IF NOT EXISTS matches (
          id INT AUTO_INCREMENT PRIMARY KEY,
          user_id INT NOT NULL,
          is_singles TINYINT(1) NOT NULL,
          target_points INT NOT NULL,
          partner_id INT,
          partner_name VARCHAR(255),
          opponent_id INT,
          opponent_name VARCHAR(255),
          is_completed TINYINT(1) DEFAULT 0,
          is_win TINYINT(1),
          player_score INT DEFAULT 0,
          opponent_score INT DEFAULT 0,
          date DATETIME DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY (user_id) REFERENCES users(id)
        )
      `;

    connection.query(createMatchesTable, (err) => {
      if (err) {
        console.error('Error creating matches table:', err);
      } else {
        console.log('Matches table ready');
      }
      connection.release(); // Release the connection back to the pool
    });
  });
  });
});

// Middleware
app.use(cors({
  origin: '*', // Allow all origins
  methods: ['GET', 'POST', 'PUT'], // Allow GET, POST, and PUT requests
  allowedHeaders: ['Content-Type', 'Authorization'] // Allow these headers
}));
app.use(bodyParser.json({ limit: '50mb' }));

// API routes for web app
app.use('/api', (req, res, next) => {
  // Remove the /api prefix from the path
  req.url = req.url.replace(/^\/api/, '');
  next();
});

// Registration endpoint
app.post('/register', (req, res) => {
  const { mobile, password, name, profile_picture } = req.body;
  const query = 'INSERT INTO users (mobile, password, name, profile_picture) VALUES (?, ?, ?, ?)';
  pool.query(query, [mobile, password, name, profile_picture], (err, result) => {
    if (err) {
      console.error('Error registering user:', err);
      return res.status(500).json({ success: false });
    }
    res.json({ 
      success: true, 
      user: { 
        id: result.insertId, 
        mobile: mobile,
        name: name,
        profile_picture: profile_picture 
      } 
    });
  });
});

// Login endpoint
app.post('/login', (req, res) => {
  console.log('Login request received:', req.body);

  // Check if mobile and password are provided
  if (!req.body.mobile || !req.body.password) {
    console.error('Missing mobile or password in request');
    return res.status(400).json({ 
      success: false, 
      error: 'Missing mobile or password' 
    });
  }

  const { mobile, password } = req.body;
  console.log(`Attempting login for mobile: ${mobile}`);

  const query = 'SELECT * FROM users WHERE mobile = ? AND password = ?';
  pool.query(query, [mobile, password], (err, results) => {
    if (err) {
      console.error('Database error during login:', err);
      return res.status(500).json({ 
        success: false, 
        error: 'Database error' 
      });
    }

    console.log(`Query results: ${results.length} matches found`);

    if (results.length > 0) {
      console.log('Login successful for user:', results[0].mobile);
      res.json({ 
        success: true, 
        user: results[0] 
      });
    } else {
      console.log('Login failed: Invalid credentials');
      res.json({ 
        success: false, 
        error: 'Invalid credentials' 
      });
    }
  });
});

// Forgot password endpoint
app.post('/forgot-password', (req, res) => {
  const { mobile } = req.body;
  const query = 'SELECT * FROM users WHERE mobile = ?';
  pool.query(query, [mobile], (err, results) => {
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

// Create a new match
app.post('/matches', (req, res) => {
  const { user_id, is_singles, target_points, partner_id, partner_name, opponent_id, opponent_name } = req.body;

  const query = `
    INSERT INTO matches 
    (user_id, is_singles, target_points, partner_id, partner_name, opponent_id, opponent_name) 
    VALUES (?, ?, ?, ?, ?, ?, ?)
  `;

  pool.query(query, [user_id, is_singles, target_points, partner_id, partner_name, opponent_id, opponent_name], (err, result) => {
    if (err) {
      console.error('Error creating match:', err);
      return res.status(500).json({ success: false, error: 'Database error' });
    }

    res.json({ 
      success: true, 
      match: { 
        id: result.insertId, 
        user_id, 
        is_singles, 
        target_points, 
        partner_id, 
        partner_name,
        opponent_id,
        opponent_name,
        is_completed: 0,
        player_score: 0,
        opponent_score: 0,
        date: new Date()
      } 
    });
  });
});

// Get matches for a user
app.get('/matches/:userId', (req, res) => {
  const userId = req.params.userId;
  const query = 'SELECT * FROM matches WHERE user_id = ? ORDER BY date DESC';

  pool.query(query, [userId], (err, results) => {
    if (err) {
      console.error('Error getting matches:', err);
      return res.status(500).json({ success: false, error: 'Database error' });
    }

    res.json({ success: true, matches: results });
  });
});

// Update a match (record result)
app.put('/matches/:matchId', (req, res) => {
  const matchId = req.params.matchId;
  const { is_completed, is_win, player_score, opponent_score } = req.body;

  const query = `
    UPDATE matches 
    SET is_completed = ?, is_win = ?, player_score = ?, opponent_score = ? 
    WHERE id = ?
  `;

  pool.query(query, [is_completed, is_win, player_score, opponent_score, matchId], (err, result) => {
    if (err) {
      console.error('Error updating match:', err);
      return res.status(500).json({ success: false, error: 'Database error' });
    }

    if (result.affectedRows === 0) {
      return res.status(404).json({ success: false, error: 'Match not found' });
    }

    res.json({ success: true });
  });
});

// Get all players (for partner selection)
app.get('/players', (req, res) => {
  const query = 'SELECT id, COALESCE(name, mobile) as name, profile_picture FROM users';

  pool.query(query, (err, results) => {
    if (err) {
      console.error('Error getting players:', err);
      return res.status(500).json({ success: false, error: 'Database error' });
    }

    res.json({ success: true, players: results });
  });
});

// Get user statistics for dashboard
app.get('/user-stats/:userId', (req, res) => {
  const userId = req.params.userId;

  // Get total matches played
  const totalMatchesQuery = 'SELECT COUNT(*) as total FROM matches WHERE user_id = ?';

  // Get win/loss ratio
  const winLossQuery = `
    SELECT 
      SUM(CASE WHEN is_win = 1 THEN 1 ELSE 0 END) as wins,
      SUM(CASE WHEN is_win = 0 AND is_completed = 1 THEN 1 ELSE 0 END) as losses
    FROM matches 
    WHERE user_id = ? AND is_completed = 1
  `;

  // Get singles vs doubles stats
  const matchTypesQuery = `
    SELECT 
      SUM(CASE WHEN is_singles = 1 THEN 1 ELSE 0 END) as singles,
      SUM(CASE WHEN is_singles = 0 THEN 1 ELSE 0 END) as doubles
    FROM matches 
    WHERE user_id = ?
  `;

  // Get recent matches (last 3 months)
  const recentMatchesQuery = `
    SELECT COUNT(*) as recent
    FROM matches 
    WHERE user_id = ? AND date >= DATE_SUB(NOW(), INTERVAL 3 MONTH)
  `;

  // Execute all queries in parallel
  Promise.all([
    new Promise((resolve, reject) => {
      pool.query(totalMatchesQuery, [userId], (err, results) => {
        if (err) reject(err);
        else resolve(results[0].total);
      });
    }),
    new Promise((resolve, reject) => {
      pool.query(winLossQuery, [userId], (err, results) => {
        if (err) reject(err);
        else resolve({
          wins: results[0].wins || 0,
          losses: results[0].losses || 0
        });
      });
    }),
    new Promise((resolve, reject) => {
      pool.query(matchTypesQuery, [userId], (err, results) => {
        if (err) reject(err);
        else resolve({
          singles: results[0].singles || 0,
          doubles: results[0].doubles || 0
        });
      });
    }),
    new Promise((resolve, reject) => {
      pool.query(recentMatchesQuery, [userId], (err, results) => {
        if (err) reject(err);
        else resolve(results[0].recent);
      });
    })
  ])
  .then(([totalMatches, winLoss, matchTypes, recentMatches]) => {
    // Calculate win rate percentage
    const winRate = winLoss.wins + winLoss.losses > 0 
      ? Math.round((winLoss.wins / (winLoss.wins + winLoss.losses)) * 100) 
      : 0;

    res.json({
      success: true,
      stats: {
        totalMatches,
        winLoss,
        winRate,
        matchTypes,
        recentMatches
      }
    });
  })
  .catch(err => {
    console.error('Error getting user stats:', err);
    res.status(500).json({ success: false, error: 'Database error' });
  });
});

app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});
