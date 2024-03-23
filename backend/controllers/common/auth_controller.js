const express = require("express");
const bcrypt = require("bcrypt");
const path = require("path");
const fs = require("fs");
const router = express.Router();
const jwt = require("jsonwebtoken");
const User = require("../../models/user_model");
const nodemailer = require("nodemailer");
const speakeasy = require("speakeasy");
require("dotenv").config();
const { v4: uuidv4 } = require("uuid");
const Student = require("../../models/student_model");
const Rt = require("../../models/rt_model");
const Warden = require("../../models/warden_model");
const Security = require("../../models/security_model");

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: process.env.EMAIL,
    pass: process.env.PASSWD,
  },
});

router.post("/login", async (req, res) => {
  const { email, password } = req.body;

  const user = await User.findOne({ email });
  if (!user) {
    return res.status(401).json({ message: "User not found" });
  }

  const isValidPassword = await bcrypt.compare(password, user.password);
  if (!isValidPassword) {
    return res.status(401).json({ message: "Invalid Credentials" });
  }

  if (user.role == "student") {
    const student = await Student.findOne({ uid: user.uid });

    const jwtToken = jwt.sign(
      {
        uid: user.uid,
        studentId: student.studentId,
        email: user.email,
        gender:student.gender,
        username: user.username,
        role: user.role,
        phNo: student.phNo,
        blockNo: student.blockNo,
        dept: student.dept,
        fatherName: student.fatherName,
        motherName: student.motherName,
        fatherPhNo: student.fatherPhNo,
        motherPhNo: student.motherPhNo,
        regNo: student.regNo,
        year: student.year,
        section: student.section,
        roomNo: student.roomNo,
      },
      process.env.JWT_KEY
    );

    res.json({
      jwtToken,
      uid: user.uid,
      studentId: student.studentId,
      email: user.email,
      // Email field needs to be added to student model
      gender:student.gender,
      username: user.username,
      role: user.role,
      phNo: student.phNo,
      blockNo: student.blockNo,
      dept: student.dept,
      fatherName: student.fatherName,
      motherName: student.motherName,
      fatherPhNo: student.fatherPhNo,
      motherPhNo: student.motherPhNo,
      regNo: student.regNo,
      year: student.year,
      section: student.section,
      roomNo: student.roomNo,
    });
  } else if (user.role == "rt") {
    const rt = await Rt.findOne({ uid: user.uid });
    const jwtToken = jwt.sign(
      {
        uid: user.uid,
        rtId: rt.rtId,
        isBoysHostelRt:rt.isBoysHostelRt,
        username: rt.username,
        email: rt.email,
        permanentBlock: rt.permanentBlock,
        phNo: rt.phNo,
        role: user.role,
      },
      process.env.JWT_KEY
    );
    res.json({
      jwtToken,
      uid: user.uid,
      rtId: rt.rtId,
      isBoysHostelRt: rt.isBoysHostelRt,
      username: rt.username,
      email: rt.email,
      permanentBlock: rt.permanentBlock,
      phNo: rt.phNo,
      role: user.role,
    });
  } else if (user.role == "warden") {
    const warden = await Warden.findOne({ uid: user.uid });
    const jwtToken = jwt.sign(
      {
        uid: user.uid,
        wardenId: warden.wardenId,
        username: warden.username,
        email: warden.email,
        phNo: warden.phNo,
        role: user.role,
      },
      process.env.JWT_KEY
    );
    res.json({
      jwtToken,
      uid: user.uid,
      wardenId: warden.wardenId,
      username: warden.username,
      email: warden.email,
      phNo: warden.phNo,
      role: user.role,
    });
  } else if (user.role == "security") {
    const security = await Security.findOne({ uid: user.uid });
    const jwtToken = jwt.sign(
      {
        uid: user.uid,
        securityId: security.securityId,
        username: security.username,
        email: security.email,
        phNo: security.phNo,
        role: user.role,
      },
      process.env.JWT_KEY
    );
    res.json({
      jwtToken,
      uid: user.uid,
      securityId: security.securityId,
      username: security.username,
      email: user.email,
      phNo: security.phNo,
      role: user.role,
    });
  }
});

router.get("/dummyOtp", async (req, res) => {
  const otp = "988643";
  try {
    const mailOptions = {
      from: "SVCE HOSTEL MANAGEMENT SYSTEM",
      to: "naveen.akash0904@gmail.com",
      subject: "Hostel Password Reset OTP",
      html: `
        <html>
          <head>
          <style>
          body {
            font-family: 'Arial', sans-serif;
            background-color: #fffbff;
            margin: 0;
            padding: 0;
          }

          .container {
            max-width: 600px;
            margin: 0 auto;
            background-color: #fffbff;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
          }

          .header {
            background-color: #e4d5fb;
            color: #6f43c0;
            text-align: center;
            padding: 20px;
          }

          .content {
            padding: 30px;
            text-align: center;
          }

          .content h2 {
            color: #6f43c0;
          }

          .otp {
            font-size: 24px;
            font-weight: bold;
            color: #6f43c0;
            margin-top: 20px;
          }

          .footer {
            background-color: #eeeeee;
            padding: 10px;
            text-align: center;
            font-size: 12px;
          }
        </style>
          </head>
          <body>
            <div class="container">
              <div class="header">
                <h1>SVCE Hostel Management System</h1>
              </div>
              <div class="content">
                <h2>Hi Nanthanavalli</h2>
                <p>You have requested to reset your password. Use the following OTP:</p>
                <div class="otp">${otp}</div>
              </div>
              <div class="footer">
                <p>If you did not request a password reset, please ignore this email.</p>
              </div>
            </div>
          </body>
        </html>
      `,
    };
    await transporter.sendMail(mailOptions);
    res.send("Dummy email sent successfully!");
  } catch (error) {
    console.log(error);
    res.status(500).send("Internal server error");
  }
});

router.post("/forgotPassword", async (req, res) => {
  try {
    const { email } = req.body;

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    if (!user.otpSecret) {
      const otpSecret = speakeasy.generateSecret().base32;
      user.otpSecret = otpSecret;
      await user.save();
    }
    // Generate OTP
    const otp = speakeasy.totp({
      secret: user.otpSecret,
      encoding: "base32",
    });

    const mailOptions = {
      from: process.env.EMAIL,
      to: user.email,
      subject: "Password Reset OTP",
      html: `
      <html>
      <head>
        <style>
          body {
            font-family: 'Arial', sans-serif;
            background-color: #fffbff;
            margin: 0;
            padding: 0;
          }

          .container {
            max-width: 600px;
            margin: 0 auto;
            background-color: #fffbff;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
          }

          .header {
            background-color: #e4d5fb;
            color: #6f43c0;
            text-align: center;
            padding: 20px;
          }

          .content {
            padding: 30px;
            text-align: center;
          }

          .content h2 {
            color: #6f43c0;
          }

          .otp {
            font-size: 24px;
            font-weight: bold;
            color: #6f43c0;
            margin-top: 20px;
          }

          .footer {
            background-color: #eeeeee;
            padding: 10px;
            text-align: center;
            font-size: 12px;
          }
        </style>
      </head>
      <body>
        <div class="container">
          <div class="header">
            <h1>SVCE Hostel Management System</h1>
          </div>
          <div class="content">
            <h2>Hi ${user.username}</h2>
            <p>You have requested to reset your password. Use the following OTP:</p>
            <div class="otp">${otp}</div>
          </div>
          <div class="footer">
            <p>If you did not request a password reset, please ignore this email.</p>
          </div>
        </div>
      </body>
    </html>`,
    };

    await transporter.sendMail(mailOptions);

    res.json({ message: "OTP sent successfully" });
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: "Internal server error" });
  }
});

router.post("/verifyOtp", async (req, res) => {
  try {
    const { email, otp } = req.body;

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    if (!user.otpSecret) {
      return res.status(400).json({ message: "OTP secret not found" });
    }

    const isValidOTP = speakeasy.totp.verify({
      secret: user.otpSecret,
      encoding: "base32",
      token: otp,
      window: 6,
    });

    if (!isValidOTP) {
      return res.status(401).json({ message: "Invalid OTP" });
    }

    res.json({ message: "OTP verified successfully" });
  } catch (error) {
    res.status(500).json({ message: "Internal server error" });
  }
});

router.post("/resetPassword", async (req, res) => {
  try {
    const { email, otp, password } = req.body;

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    if (!user.otpSecret) {
      return res.status(400).json({ message: "OTP secret not found" });
    }

    const isValidOTP = speakeasy.totp.verify({
      secret: user.otpSecret,
      encoding: "base32",
      token: otp,
      window: 6,
    });
    if (!isValidOTP) {
      return res.status(401).json({ message: "Invalid OTP" });
    }

    // Update password and clear OTP secret
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);
    user.password = hashedPassword;
    user.otpSecret = undefined;
    await user.save();

    res.json({ message: "Password reset successful" });
  } catch (error) {
    res.status(500).json({ message: "Internal server error" });
  }
});

// router.get("/dummy", async (req, res) => {
//   const uid = "user_" + uuidv4();
//   const securityId = "security_" + uuidv4();
//   try {
//     await new User({
//       username: "Security 1",
//       email: "security1@gmail.com",
//       password: "$2b$10$sW1Ay1MBfv7/Tv33C4bdaOmvPTP3Vd/LFah/Dw2XDqfEBX2ZCoLRK",
//       uid: uid,
//       role: "security",
//     }).save();

//     await new Security({
//       email: "security1@gmail.com",
//       username: "Security 1",
//       phNo: "0987654321",
//       securityId: securityId,
//       uid: uid,

//       // RT
//       // email: "naveen.akash0904@gmail.com",
//       // name: "RT",
//       // phno: "9876543210",
//       // photoPath: "sd/sd/sd",
//       // uid: uid,
//       // rtId: rtId,
//       // block: 3,

//       // STUDENT
//       // block: 3,
//       // dept: "Information Technology",
//       // fatherName: "Kamal",
//       // motherName: "Priya",
//       // fatherPhNo: "1234567890",
//       // motherPhNo: "0987654321",
//       // name: "Naveen",
//       // uid: uid,
//       // phNo: "6789054321",
//       // photoPath: "/sd/sd/sd",
//       // regNo: "2127210801066",
//       // roomNo: 312,
//       // section: "B",
//       // studentId: "2021it0668",
//       // year: 3,
//     }).save();

//     res.send();
//   } catch (e) {
//     res.status(500).send();
//   }
// });

module.exports = router;
