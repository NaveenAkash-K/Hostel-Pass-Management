const express = require("express");
const router = express.Router();
const path = require("path");
const fs = require("fs");
require("dotenv").config();
const Qr = require("../../models/qr_model");
const Student = require("../../models/student_model");
const Rt = require("../../models/rt_model");
const Warden = require("../../models/warden_model");
const Security = require("../../models/security_model");
const Pass = require("../../models/pass_model");
const { aesEncrypt, aesDecrypt } = require("../../utils/aes");

router.get("/getDetails/:qrData", async (req, res) => {
  const qrId = aesDecrypt(req.params.qrData, process.env.AES_KEY);

  const qr = await Qr.findOne({ qrId: qrId });
  const pass = await Pass.findOne({ passId: qr.passId, isActive: true });
  const student = await Student.findOne({ studentId: pass.studentId });

  let photoFilePath = path.join(
    __dirname + "../../../images/profiles/student/" + student.studentId + ".jpg"
  );
  
  const photoBuffer = fs.readFileSync(photoFilePath);
  const profileBuffer = photoBuffer.toString("base64");

  if (
    new Date(pass.expectedOut).getTime() + 60 * 60000 < Date.now() &&
    pass.status === "Approved"
  ) {
    res.status(400).json({ message: "QR expired" });
    return;
  }

  if (
    new Date(pass.exitScanAt).getTime() + 30 * 60000 > Date.now() &&
    pass.status === "In use"
  ) {
    res
      .status(400)
      .json({ message: "Entry scan should be after 30 mins of Exit scan" });
    return;
  }

  // let photoFilePath;

  // photoFilePath = path.join(
  //   __dirname + "../../../images/profiles/student/" + pass.studentId + ".jpg"
  // );

  // const photoBuffer = fs.readFileSync(photoFilePath);
  // const profileBuffer = photoBuffer.toString("base64");

  res.json({
    // profileBuffer,
    username: student.username,
    roomNo: student.roomNo,
    passType: pass.type,
    leavingDateTime: `${pass.expectedOut}`,
    returningDateTime: `${pass.expectedIn}`,
    approvedBy: pass.approvedBy,
    exitScanBy: pass.exitScanBy,
    entryScanBy: pass.entryScanBy,
    exitScanAt: pass.exitScanAt,
    entryScanAt: pass.entryScanAt,
    profileBuffer: profileBuffer,
  });
});

router.get("/getPass", async (req, res) => {
  try {
    const allStudents = await Student.find({});

    let passes = [];
    for (const student of allStudents) {
      const studentPasses = await Pass.find({
        studentId: student.studentId,
        // isSpecialPass: true,
      });

      for (const pass of studentPasses) {
        passes.push({
          ...pass._doc,
          studentName: student.username,
          gender: student.gender,
          dept: student.dept,
          fatherPhNo: student.fatherPhNo,
          motherPhNo: student.motherPhNo,
          phNo: student.phNo,
          blockNo: student.blockNo,
          roomNo: student.roomNo,
          year: student.year,
          isLate:
            new Date(pass.entryScanAt).getTime() >
            new Date(pass.expectedIn).getTime() + 60 * 60000,
        });
      }
    }

    passes.sort((a, b) => {
      return new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime();
    });

    res.json(passes);
  } catch (error) {
    res.status(500).json({ message: "Internal Server Error" });
  }
});

router.post("/confirmScan/:qrData", async (req, res) => {
  const qrId = aesDecrypt(req.params.qrData, process.env.AES_KEY);
  const qr = await Qr.findOne({ qrId: qrId });
  const pass = await Pass.findOne({ passId: qr.passId, isActive: true });

  if (pass.exitScanAt == undefined) {
    pass.exitScanBy = req.body.USER_username;
    pass.exitScanAt = req.body.scanAt;
    pass.status = "In use";
    await pass.save();
  } else if (pass.entryScanAt == undefined) {
    console.log(qrId);
    pass.entryScanBy = req.body.USER_username;
    pass.entryScanAt = req.body.scanAt;
    pass.status = "Used";
    pass.isActive = false;
    await pass.save();
    await Qr.deleteOne({ qrId: qrId });
  }

  res.json({ message: "Scan successful" });
});
module.exports = router;
