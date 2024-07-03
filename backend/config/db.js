const mysql = require('mysql');

const db = mysql.createPool({
    connectionLimit: 10,
    host: "localhost",
    user: "root",
    password: "root",
    database: "taskmanagerapplication",
    insecureAuth: true, // This line is added to handle the authentication issue
    authSwitchHandler: (data, cb) => {
        if (data.pluginName === 'caching_sha2_password') {
            // Switch to the mysql_native_password authentication plugin
            const password = ''; // Replace '' with the actual password of your MySQL user
            cb(null, Buffer.from(password + '\0'));
        }
    }
});

db.getConnection((err, connection) => {
    if (err) {
        console.error('Error connecting to database:', err);
        return;
    }
    console.log('Connected to database as ID', connection.threadId);
});

module.exports = db;