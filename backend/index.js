const express = require('express');

const mydb = require("./config/db");

const app = express();

const cors = require('cors');

const router = require("./routes/router");

const bodyParser = require('body-parser');

// For parsing application/json
app.use(bodyParser.json());

// For parsing application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({ extended: true }));

app.use(router);



// Define the list of allowed origins
const allowedOrigins = [
  'http://192.168.100.115:3000',
  'http://localhost:8080'
];

// Configure CORS to allow requests from the specified origins
app.use(cors({
  origin: function (origin, callback) {
    // Allow requests with no origin (like mobile apps or curl requests)
    if (!origin) return callback(null, true);
    if (allowedOrigins.indexOf(origin) === -1) {
      const msg = 'The CORS policy for this site does not allow access from the specified Origin.';
      return callback(new Error(msg), false);
    }
    return callback(null, true);
  },
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  //allowedHeaders: ['Content-Type', 'Authorization'],
  //credentials: true,
}));

// Ensure preflight requests are handled
app.options('*', cors({
  origin: function (origin, callback) {
    if (!origin) return callback(null, true);
    if (allowedOrigins.indexOf(origin) === -1) {
      const msg = 'The CORS policy for this site does not allow access from the specified Origin.';
      return callback(new Error(msg), false);
    }
    return callback(null, true);
  },
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  //allowedHeaders: ['Content-Type', 'Authorization'],
  //credentials: true,
}));


app.listen(3000,()=>{
    console.log("server is running");
});


