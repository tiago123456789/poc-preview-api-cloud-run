const express = require("express");
const app = express();

app.get("/", (req, res) => {
  res.json({
    message: "Hello world",
  });
});

app.get("/test", (req, res) => {
  res.json({
    message: "Test message",
  });
});

app.get("/hi", (req, res) => {
  res.json({
    message: "Hi, my friend!!!!",
  });
});

app.listen(8080, () => {
  console.log("Server is running at port 3000");
});
