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

  console.log(qrId);
  
  const qr = await Qr.findOne({ qrId: qrId });
  const pass = await Pass.findOne({ passId: qr.passId, isActive: true });
  const student = await Student.findOne({ studentId: pass.studentId });

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
    leavingTime: `${pass.expectedOutDate} ${pass.expectedOutTime}`,
    returningTime: `${pass.expectedInDate} ${pass.expectedInTime}`,
    approvedBy: pass.approvedBy,
  });
});
router.get("/confirmScan/:qrId", async (req, res) => {});
module.exports = router;