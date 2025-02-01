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

app.listen(8080, () => {
  console.log("Server is running at port 3000");
});
