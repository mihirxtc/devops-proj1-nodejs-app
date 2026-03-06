const express = require('express');
const app = express();
const PORT = process.env.PORT || 5000;

app.get('/', (req, res) => {
    res.send('<h1>DEVOPS/CLOUD ENGINEERING from mihirxtc</h1>');
});

app.get('/devops', (req, res) => {
    res.send('<h1>Welcome to devops page</h1>');
});

app.get('/aws', (req, res) => {
    res.send('<h1>Welcome to aws page</h1>');
});

app.get('/kubernetes', (req, res) => {
    res.send('<h1>Welcome to kubernetes page</h1>');
});

app.get('/docker', (req, res) => {
    res.send('<h1>Welcome to docker page</h1>');
});

app.get('/terraform', (req, res) => {
    res.send('<h1>Welcome to terraform page</h1>');
});

app.get('/ansible', (req, res) => {
    res.send('<h1>Welcome to ansible page</h1>');
});

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});