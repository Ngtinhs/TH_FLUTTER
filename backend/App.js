var express = require("express");
var path = require("path");
var cookieParser = require("cookie-parser");
var bodyParser = require("body-parser");
var mongoose = require("mongoose");
const cors = require("cors");

var users = require("./routes/user");
var codes = require("./routes/code");

//
var app = express();

//
// app.use(bodyParser.json());
// app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json({ limit: "10mb" })); // Đặt giới hạn là 10MB, bạn có thể điều chỉnh theo nhu cầu của bạn
app.use(bodyParser.urlencoded({ limit: "10mb", extended: true }));
app.use(cookieParser());
app.use(cors());

//
mongoose
  .connect(
    "mongodb+srv://tinh:tinh@cluster0.oxcjy73.mongodb.net/?retryWrites=true&w=majority",
    {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    }
  )
  .then(() => {
    console.log("Successfully connected to the database");
  })
  .catch((err) => {
    console.log("Could not connect to the database. Exiting now...", err);
    process.exit();
  });

//
app.use((req, res, next) => {
  res.setHeader("Access-Control-Allow-Origin", "http://localhost:3000");
  next();
});

app.use("/api/users", users);
app.use("/api/code", codes);
const port = process.env.PORT || 8000;
app.listen(port, () => {
  console.log(`Server is working on http://localhost:${port}`);
});
