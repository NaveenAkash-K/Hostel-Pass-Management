const express = require("express");
const bcrypt = require("bcrypt");
const router = express.Router();
const jwt = require("jsonwebtoken");
const User = require("../../models/user_model");
const Pass = require("../../models/pass_model");
const QR = require("../../models/qr_model");
const Student = require("../../models/student_model");
const { v4: uuidv4 } = require("uuid");
const { aesEncrypt, aesDecrypt } = require("../../utils/aes");

router.get("/getPass", async (req, res) => {
  try {
    const blockStudents = await Student.find({
      blockNo: req.body.USER_permanentBlock,
    });

    var passes = [];
    for (let student of blockStudents) {
      var tempPass = [];
      var studentPasses = await Pass.find({
        studentId: student.studentId,
      });
      for (const pass of studentPasses) {
        tempPass.push({
          ...pass._doc,
          studentName: student.username,
          dept: student.dept,
          fatherPhNo: student.fatherPhNo,
          motherPhNo: student.motherPhNo,
          phNo: student.phNo,
          roomNo: student.roomNo,
          year: student.year,
        });
      }
      passes.push(...tempPass);
    }
    res.json({ data: passes });
  } catch (error) {
    res.status(500).json({ message: "Internal Server Error" });
  }
});

router.get("/approvePass", async (req, res) => {
  try {
  } catch (error) {
    res.status(500).json({ message: "Internal Server Error" });
  }
});

router.get("/rejectPass", async (req, res) => {
  try {
  } catch (error) {
    res.status(500).json({ message: "Internal Server Error" });
  }
});

module.exports = router;
