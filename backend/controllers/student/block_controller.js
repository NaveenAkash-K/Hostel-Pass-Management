const express = require("express");
const router = express.Router();
const Announcement = require("../../models/announcement_model");

router.get("/getAnnouncement/:blockNo", async (req, res) => {
  try {
    const blockNo = req.params.blockNo;
    const announcement = await Announcement.find({ blockNo: blockNo });
    console.log(announcement);
    res.json(announcement);
  } catch (err) {
    console.log(err);
    res.status(500).json({ message: "Internal server error" });
  }
});

router.post("/readAnnouncement", async (req, res) => {
  try {
    const {id} = req.body;
const announcement = await Announcement.findOneAndUpdate(
  { _id: id },
  { isRead: true },
  { new: true } 
);
if(!announcement){
  res.status(404).json({message:"Announcement not found"});
}
    res.json(announcement);
  } catch (err) {
    console.log(err);
    res.status(500).json({ message: "Internal server error" });
  }
});
module.exports = router;
