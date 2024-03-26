const express = require("express");
const path = require("path");
const fs = require("fs");
const router = express.Router();
const Student = require("../../models/student_model");
const Rt = require("../../models/rt_model");
const Announcement = require("../../models/announcement_model");

router.get("/getStudents", async (req, res, next) => {
  try {
    const filteredStudents = await Student.find({
      blockNo: req.body.USER_permanentBlock,
    });

    let blockStudents = [];

    for (const student of filteredStudents) {
      blockStudents.push({
        ...student._doc,
        email: student._doc.studentId + "@svce.ac.in",
      });
    }

    console.log(blockStudents);
    res.json(blockStudents);
  } catch (e) {
    console.log(e);
    res.status(400).json({ message: "Internal Server Error" });
  }
});

router.post("/postAnnouncement", async (req, res) => {
  try {
    const { title, message, blockNo, rtId, isBoysHostelRt } = req.body;
    const announcement = await new Announcement({
      title: title,
      message: message,
      blockNo: blockNo,
      rtId: rtId,
      isBoysHostelRt: isBoysHostelRt,
      isRead: false,
    }).save();
    res.json({
      _id: announcement._id,
      rtId: announcement.rtId,
      title: announcement.title,
      isRead: announcement.isRead,
      blockNo: announcement.blockNo,
      message: announcement.message,
      isBoysHostelRt: announcement.isBoysHostelRt,
    });
  } catch (err) {
    console.log(err);
    res.status(500).json({ message: "Internal server error" });
  }
});
router.get("/getAnnouncement/:blockNo", async (req, res) => {
  try {
    const blockNo = req.params.blockNo;
    const announcement = await Announcement.find({ blockNo: blockNo });
    res.json(announcement);
  } catch (err) {
    console.log(err);
    res.status(500).json({ message: "Internal server error" });
  }
});
router.delete("/deleteAnnouncement/:announcementId", async (req, res) => {
  try {
    const annoucementId = req.params.announcementId;
    const announcement = await Announcement.findOneAndDelete({
      _id: annoucementId,
    });
    res.json(announcement);
  } catch (err) {
    console.log(err);
    res.status(500).json({ message: "Internal server error" });
  }
});
router.post("/switchRt", async (req, res) => {
  try {
    const { blockNo } = req.body;
    const permanentBlockNo = req.body.USER_permanentBlock;
    const isBoysHostelRt = req.body.USER_isBoysHostelRt;

    const switchedRt = await Rt.findOneAndUpdate(
      { permanentBlock: blockNo, isBoysHostelRt:isBoysHostelRt },
      { $addToSet: { temporaryBlock: permanentBlockNo } },
      { new: true }
    );

    if (!switchedRt) {
      return res.status(404).json({ message: "RT not found" });
    }

    res.json(switchedRt);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Internal server error" });
  }
});

router.post("/revertSwitchRt", async (req, res) => {
  try {
    const permanentBlockNo = req.body.USER_permanentBlock;    
    const isBoysHostelRt = req.body.USER_isBoysHostelRt;


    const allRts = await Rt.updateMany(
      { temporaryBlock: permanentBlockNo, isBoysHostelRt:isBoysHostelRt },
      { $pull: { temporaryBlock: permanentBlockNo } }
    );

    res.json({ message: "Rts reverted successfully" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Internal server error" });
  }
});

// router.get("/getSwitchedRts", async (req, res) => {
//   try {
//     const permanentBlock = req.body.USER_permanentBlock;

//     const docs = await Rt.find({});

//     const rtArray = docs
//       .filter((doc) => doc.temporaryBlock.includes(permanentBlock))
//       .map((doc) => ({
//         uid: doc.uid,
//         permanentBlock: doc.permanentBlock,
//         rtName: doc.username,
//       }));

//     res.json(rtArray);
//   } catch (error) {
//     console.error("Error fetching rt documents:", error);
//     res.status(500).json({ error: "Internal server error" });
//   }
// });

router.get("/getSwitchedRts", async (req, res) => {
  try {
    const permanentBlock = req.body.USER_permanentBlock;
    const isBoysHostelRt = req.body.USER_isBoysHostelRt; // Assuming this is a boolean value

    const docs = await Rt.find({ temporaryBlock: { $in: [permanentBlock] } });

    let maleFilteredRts = [];
    let femaleFilteredRts = [];

    docs.forEach((doc) => {
      if (isBoysHostelRt && doc.isBoysHostelRt) {
        maleFilteredRts.push({
          uid: doc.uid,
          permanentBlock: doc.permanentBlock,
          rtName: doc.username,
        });
      } else if (!isBoysHostelRt && !doc.isBoysHostelRt) {
        femaleFilteredRts.push({
          uid: doc.uid,
          permanentBlock: doc.permanentBlock,
          rtName: doc.username,
        });
      }
    });

    if (isBoysHostelRt) {
      console.log(maleFilteredRts);
      res.json(maleFilteredRts);
    } else {
            console.log(femaleFilteredRts);

      res.json(femaleFilteredRts);
    }
  } catch (error) {
    console.error("Error fetching rt documents:", error);
    res.status(500).json({ error: "Internal server error" });
  }
});


module.exports = router;
