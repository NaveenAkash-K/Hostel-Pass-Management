const express = require("express");
const BugReport = require("../../models/bug_report_model");
const Rt = require("../../models/rt_model");
const path = require("path");
const fs = require("fs");
const { setTimeout } = require("timers");
const router = express.Router();

router.get("/fetch", async (req, res, next) => {
  try {
    const role = req.body.USER_role;
    let photoFilePath;
    let rt;

    if (role === "student") {
      photoFilePath = path.join(
        __dirname +
          "../../../images/profiles/" +
          role +
          "/" +
          req.body.USER_studentId +
          ".jpg"
      );
    } else if (role === "warden") {
      photoFilePath = path.join(
        __dirname +
          "../../../images/profiles/" +
          role +
          "/" +
          req.body.USER_wardenId +
          ".jpg"
      );
    } else if (role === "rt") {
      rt = await Rt.findOne({ rtId: req.body.USER_rtId });
      photoFilePath = path.join(
        __dirname +
          "../../../images/profiles/" +
          role +
          "/" +
          req.body.USER_rtId +
          ".jpg"
      );
    } else if (role === "security") {
      photoFilePath = path.join(
        __dirname +
          "../../../images/profiles/" +
          role +
          "/" +
          req.body.USER_securityId +
          ".jpg"
      );
    }

    const photoBuffer = fs.readFileSync(photoFilePath);
    const profileBuffer = photoBuffer.toString("base64");

    res.json({
      profileBuffer: profileBuffer,
      temporaryBlock: rt ? rt.temporaryBlock : undefined,
    });
  } catch (error) {
    console.log(error);
    res.status(400).json({ message: "Internal Server Error" });
  }
});

router.get("/studentProfile/:studentId", async (req, res, next) => {
  try {
    const role = req.body.USER_role;

    if (role === "student") {
      res.status(401).json({ message: "Unauthenticated" });
      return;
    }

    let photoFilePath;

    photoFilePath = path.join(
      __dirname +
        "../../../images/profiles/student/" +
        req.params.studentId +
        ".jpg"
    );

    const photoBuffer = fs.readFileSync(photoFilePath);
    const profileBuffer = photoBuffer.toString("base64");

    res.json({ profileBuffer: profileBuffer });
  } catch (error) {
    console.log(error);
    res.status(400).json({ message: "Internal Server Error" });
  }
});

module.exports = router;
