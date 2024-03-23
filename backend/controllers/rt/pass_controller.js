const express = require("express");
const bcrypt = require("bcrypt");
const router = express.Router();
const jwt = require("jsonwebtoken");
const User = require("../../models/user_model");
const Pass = require("../../models/pass_model");
const QR = require("../../models/qr_model");
const Student = require("../../models/student_model");
const Rt = require("../../models/rt_model");
const { v4: uuidv4 } = require("uuid");
const { aesEncrypt, aesDecrypt } = require("../../utils/aes");

router.get("/getPass", async (req, res) => {
  try {
    const rt = await Rt.findOne({
      uid: req.body.USER_uid,
    });

    if (!rt) {
      return res.status(404).json({ message: "Rt not found" });
    }
    const tempBlocks = rt.temporaryBlock;
    const blockStudents = await Student.find({
      blockNo: { $in: [...tempBlocks, req.body.USER_permanentBlock] },
    });
    var passes = [];
    for (let student of blockStudents) {
      var tempPass = [];
      var studentPasses = await Pass.find({
        studentId: student.studentId,
        // isSpecialPass: false,
      });
      for (const pass of studentPasses) {
        tempPass.push({
          ...pass._doc,
          studentName: student.username,
          gender: student.gender,
          dept: student.dept,
          fatherPhNo: student.fatherPhNo,
          motherPhNo: student.motherPhNo,
          phNo: student.phNo,
          roomNo: student.roomNo,
          blockNo: student.blockNo,
          year: student.year,
          isLate:
            new Date(pass.entryScanAt).getTime() >
            new Date(pass.expectedIn).getTime() + 60 * 60000,
        });
      }
      passes.push(...tempPass);
    }
    console.log(passes);

    passes.sort((a, b) => {
      return new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime();
    });

    res.json({ data: passes });
  } catch (error) {
    res.status(500).json({ message: "Internal Server Error" });
  }
});
// router.get("/getPass", async (req, res) => {
//   try {
//     const blockStudents = await Student.find({
//       blockNo: req.body.USER_permanentBlock,
//     });

//     var passes = [];
//     for (let student of blockStudents) {
//       var tempPass = [];
//       var studentPasses = await Pass.find({
//         studentId: student.studentId,
//         // isSpecialPass: false,
//       });
//       for (const pass of studentPasses) {
//         tempPass.push({
//           ...pass._doc,
//           studentName: student.username,
//           dept: student.dept,
//           fatherPhNo: student.fatherPhNo,
//           motherPhNo: student.motherPhNo,
//           phNo: student.phNo,
//           roomNo: student.roomNo,
//           blockNo:student.blockNo,
//           year: student.year,
//         });
//       }
//       passes.push(...tempPass);
//     }
//     res.json({ data: passes });
//   } catch (error) {
//     res.status(500).json({ message: "Internal Server Error" });
//   }
// });

router.post("/approvePass", async (req, res) => {
  try {
    const { passId, rtName, confirmedWith } = req.body;
    const pass = await Pass.findOneAndUpdate(
      { passId: passId },
      { status: "Approved", approvedBy: rtName, confirmedWith: confirmedWith },
      { new: true }
    );
    if (!pass) {
      return res.status(404).json({ message: "Pass not found" });
    }
    res.json(pass);
  } catch (error) {
    console.error("Error approving pass:", error);
    res.status(500).json({ message: "Internal Server Error" });
  }
});

router.post("/rejectPass", async (req, res) => {
  try {
    const { passId, rtName } = req.body;
    const pass = await Pass.findOneAndUpdate(
      { passId: passId },
      {
        status: "Rejected",
        isActive: false,
        approvedBy: rtName,
        confirmedWith: "None",
      },
      { new: true }
    );
    if (!pass) {
      return res.status(404).json({ message: "Pass not found" });
    }
    res.json(pass);
  } catch (error) {
    console.error("Error rejecting pass:", error);
    res.status(500).json({ message: "Internal Server Error" });
  }
});

module.exports = router;
