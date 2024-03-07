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

    if(!rt){
      return res.status(404).json({message:"Rt not found"})
    }
    const tempBlocks = rt.temporaryBlock;
    const blockStudents = await Student.find({
      blockNo: { $in: [...tempBlocks,req.body.USER_permanentBlock] },
    });
    console.log(blockStudents);
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
          dept: student.dept,
          fatherPhNo: student.fatherPhNo,
          motherPhNo: student.motherPhNo,
          phNo: student.phNo,
          roomNo: student.roomNo,
          blockNo:student.blockNo,
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

router.post("/approvePass/:passId", async (req, res) => {
  try {
    const passId = req.params.passId;
    const pass = await Pass.findOneAndUpdate(
      { passId: passId },
      { status: "Approved" },
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


router.post("/rejectPass/:passId", async (req, res) => {
  try {
    const passId = req.params.passId;
    const pass = await Pass.findOneAndUpdate(
      { passId: passId },
      { status: "Rejected" , isActive:false},
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
