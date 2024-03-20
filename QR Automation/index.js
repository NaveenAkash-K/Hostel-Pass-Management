const nodemailer = require("nodemailer");
const QRCode = require("qrcode");
const xlsx = require("xlsx");
const path = require("path");
const app = require("express")();
const mongoose = require("mongoose");
const fs = require("fs");
const uuidv4 = require("uuid").v4;
const User = require("./user_model.js");
const Student = require("./student_model.js");
const Rt = require("./rt_model.js");
const Security = require("./security_model.js");
require("dotenv").config();

mongoose.connect(process.env.MONGO_URI, {});

mongoose.connection.on("error", (err) => {
  console.error("MongoDB connection error:", err);
});


app.get("/user", async (req, res) => {
  // const excelFilePath = path.join(__dirname, "test.xlsx");
  const excelFilePath = path.join(
    __dirname,
    "Hostel Pass Management App (Responses).xlsx"
  );
  const workbook = xlsx.readFile(excelFilePath);
  const sheetName = workbook.SheetNames[0];
  const sheet = workbook.Sheets[sheetName];
  const datas = xlsx.utils.sheet_to_json(sheet);

  var i = 1;

  for (const data of datas) {
    const uid = "user_" + uuidv4();


    // const qrCodeBuffer = await QRCode.toBuffer(ordId);

    try {
      const user = await new User({
        uid: uid,
        username: data.Name,
        email: data.email,
        password:
          "$2b$10$l0ABfrzZkuAReqs/23sYcule9VfYKHzuQH90oHeiXn1iHRZGxPbjG",
        role: "student",
      }).save();

      console.log(i, user.email, "DB Update Success");
      fs.appendFile(
        path.join(__dirname, "log.txt"),
        i + ". " + user.email + " DB Update Success\n",
        (err) => {
          if (err) {
            console.log("Log append failed");
          }
        }
      );

    } catch (error) {
      console.error("Error processing data:", error);
      fs.appendFile(
        path.join(__dirname, "log.txt"),
        error.message + "\n",
        (err) => {
          if (err) {
            console.log("Log append failed");
          }
        }
      );
      await new Promise((resolve) => setTimeout(resolve, 5000)); // Wait for 5 seconds before retrying
      i++;
      continue; // Skip to the next iteration of the loop
    }
  }
  console.log("Completed");
  res.send("Completed");
});

app.get("/student", async (req, res) => {
  // const excelFilePath = path.join(__dirname, "test.xlsx");
  const excelFilePath = path.join(
    __dirname,
    "Hostel Pass Management App (Responses).xlsx"
  );
  const workbook = xlsx.readFile(excelFilePath);
  const sheetName = workbook.SheetNames[0];
  const sheet = workbook.Sheets[sheetName];
  const datas = xlsx.utils.sheet_to_json(sheet);

  var i = 1;

  for (const data of datas) {
    const uid = "user_"+uuidv4();
    // const qrCodeBuffer = await QRCode.toBuffer(ordId);

    try {
      const user = await new Student({
        studentId: uid,
        regNo:data.regno,
        uid:uid,
        gender:'M',
        username:data.Name,
        phNo:data.phonenumber,
        fatherName:data.fathername,
        motherName:data.mothername,
        fatherPhNo:data.fatherphoneno,
        motherPhNo:data.motherphoneno,
        dept:data.Department,
        year:data.Year,
        section:data.Section,
        roomNo:data.roomno,
        blockNo:data.blockno,
      }).save();

      console.log(i, user.email, "DB Update Success");
      fs.appendFile(
        path.join(__dirname, "log.txt"),
        i + ". " + user.email + " DB Update Success\n",
        (err) => {
          if (err) {
            console.log("Log append failed");
          }
        }
      );

    } catch (error) {
      console.error("Error processing data:", error);
      fs.appendFile(
        path.join(__dirname, "log.txt"),
        error.message + "\n",
        (err) => {
          if (err) {
            console.log("Log append failed");
          }
        }
      );
      await new Promise((resolve) => setTimeout(resolve, 5000)); // Wait for 5 seconds before retrying
      i++;
      continue; // Skip to the next iteration of the loop
    }
  }
  console.log("Completed");
  res.send("Completed");
});

app.get("/rt", async (req, res) => {
  // const excelFilePath = path.join(__dirname, "test.xlsx");
  const excelFilePath = path.join(
    __dirname,
    "Hostel Pass Management App (Responses).xlsx"
  );
  const workbook = xlsx.readFile(excelFilePath);
  const sheetName = workbook.SheetNames[1];
  const sheet = workbook.Sheets[sheetName];
  const datas = xlsx.utils.sheet_to_json(sheet);

  var i = 1;

  for (const data of datas) {
    const uid = "user_"+uuidv4();
    const rtId = "rt_"+uuidv4();
    // const qrCodeBuffer = await QRCode.toBuffer(ordId);

    try {
      const user = await new Rt({
        email: data.email,
        uid: uid,
        rtId: rtId,
        regNo: data.regno,
        uid: uid,
        username: data.Name,
        phNo: data.phonenumber,
        temporaryBlock:[],
        permanentBlock: data.permanentBlock,
        isBoysHostelRt: data.boyshostelrt,
      }).save();

      console.log(i, user.email, "DB Update Success");
      fs.appendFile(
        path.join(__dirname, "log.txt"),
        i + ". " + user.email + " DB Update Success\n",
        (err) => {
          if (err) {
            console.log("Log append failed");
          }
        }
      );

    } catch (error) {
      console.error("Error processing data:", error);
      fs.appendFile(
        path.join(__dirname, "log.txt"),
        error.message + "\n",
        (err) => {
          if (err) {
            console.log("Log append failed");
          }
        }
      );
      await new Promise((resolve) => setTimeout(resolve, 5000)); // Wait for 5 seconds before retrying
      i++;
      continue; // Skip to the next iteration of the loop
    }
  }
  console.log("Completed");
  res.send("Completed");
});

app.get("/security", async (req, res) => {
  // const excelFilePath = path.join(__dirname, "test.xlsx");
  const excelFilePath = path.join(
    __dirname,
    "Hostel Pass Management App (Responses).xlsx"
  );
  const workbook = xlsx.readFile(excelFilePath);
  const sheetName = workbook.SheetNames[2];
  const sheet = workbook.Sheets[sheetName];
  const datas = xlsx.utils.sheet_to_json(sheet);

  var i = 1;

  for (const data of datas) {
    const uid = "user_" + uuidv4();
    const securityId = "security_" + uuidv4();
    // const qrCodeBuffer = await QRCode.toBuffer(ordId);

    try {
      const user = await new Security({
        uid: uid,
        securityId: securityId,
        username: data.Name,
        phNo: data.phonenumber,
        email:data.email,
      }).save();

      console.log(i, user.email, "DB Update Success");
      fs.appendFile(
        path.join(__dirname, "log.txt"),
        i + ". " + user.email + " DB Update Success\n",
        (err) => {
          if (err) {
            console.log("Log append failed");
          }
        }
      );
    } catch (error) {
      console.error("Error processing data:", error);
      fs.appendFile(
        path.join(__dirname, "log.txt"),
        error.message + "\n",
        (err) => {
          if (err) {
            console.log("Log append failed");
          }
        }
      );
      await new Promise((resolve) => setTimeout(resolve, 5000)); // Wait for 5 seconds before retrying
      i++;
      continue; // Skip to the next iteration of the loop
    }
  }
  console.log("Completed");
  res.send("Completed");
});

mongoose.connection.once("open", () => {
  app.listen(3000, () => {
    console.log("Server started at: http://localhost:3000");
  });
});
