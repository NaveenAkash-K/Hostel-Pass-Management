const express = require("express");
const bodyParser = require("body-parser");
const mongoose = require("mongoose");
const jwt = require("jsonwebtoken");
const authController = require("./controllers/common/auth_controller");
const bugReportController = require("./controllers/common/bug_report_controller");
const profilePicController = require("./controllers/common/profile_pic_controller");
const studentRoute = require("./routes/student_route");
const securityRoute = require("./routes/security_route");
const rtRoute = require("./routes/rt_route");
const wardenRoute = require("./routes/warden_route");
const app = express();
const bcrypt = require("bcrypt");
const cors = require("cors");
const helmet = require("helmet");
require("dotenv").config();
const checkAuth = require("./middleware/checkAuth");
const Miscellaneous = require("./models/miscellaneous_model");
const path = require("path");
const fs = require("fs");

process.env.TZ = "Asia/Kolkata";

app.use(helmet());
app.use(cors());
app.use(bodyParser.json());

app.use("/test", (req, res) => {
  res.json({ message: "Hello from server" });
});

app.use("/timeTest", (req, res) => {
  const currentTime = Date.now();
  const initialTime = new Date("2024-03-19T13:57:00.000");
  const limitTime = new Date(initialTime.getTime() + 12 * 60000); // 60000 milliseconds in a minute

  if (currentTime > limitTime) {
    console.log("The time has exceeded the limit.");
  } else {
    console.log("The time has not exceeded the limit.");
  }

  res.send();
});
mongoose
  .connect(process.env.MONGO_URI)
  .then(async () => {
    app.listen(3000, () => {
      console.log("Server running on port 3000");
    });
  })
  .catch((err) => {
    console.log(err);
  });

app.get("/miscellaneous", async (req, res) => {
  try {
    const miscellaneous = await Miscellaneous.findOne({});
    res.json(miscellaneous);
  } catch (e) {
    res.json({ message: "Internal Server Error" });
  }
});

app.get("/getTime", (req, res) => {
  res.json({
    dateNow: Date.now(),
    day: new Date(Date.now()).getDay(),
    date: new Date(Date.now()).getDate(),
    month: new Date(Date.now()).getMonth(),
    hour: new Date(Date.now()).getHours(),
    minute: new Date(Date.now()).getMinutes(),
    seconds: new Date(Date.now()).getSeconds(),
    UTCdate: new Date(Date.now()).getUTCDate(),
    UTCmonth: new Date(Date.now()).getUTCMonth(),
    UTChour: new Date(Date.now()).getUTCHours(),
    UTCminute: new Date(Date.now()).getUTCMinutes(),
    UTCseconds: new Date(Date.now()).getUTCSeconds(),
  });
});

app.use("/bugReport", checkAuth, bugReportController);
app.use("/auth", authController);
app.use("/profile", checkAuth, profilePicController);
app.use("/student", checkAuth, studentRoute);
app.use("/warden", checkAuth, wardenRoute);
app.use("/rt", checkAuth, rtRoute);
app.use("/security", checkAuth, securityRoute);
