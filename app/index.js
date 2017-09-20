const express = require('express');
const app = express();

app.get('/', function (req, res) {
    res.send('<strong>I\'m OK!</strong><br/><br/>' + (new Date()).toISOString());
});

app.listen(8081);

console.log('Listening at 8081...');