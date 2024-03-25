const express = require("express");
const router = express.Router();
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

  console.log(new Date(pass.expectedOut).getTime() + 60 * 60000);
  console.log(Date.now());

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
  });
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
