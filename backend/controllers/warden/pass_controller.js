const express = require("express");
const router = express.Router();
const Student = require("../../models/student_model");
const Pass = require("../../models/pass_model");

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
          dept: student.dept,
          fatherPhNo: student.fatherPhNo,
          motherPhNo: student.motherPhNo,
          phNo: student.phNo,
          roomNo: student.roomNo,
          year: student.year,
        });
      }
    }
    res.json(passes);
  } catch (error) {
    res.status(500).json({ message: "Internal Server Error" });
  }
});

module.exports = router;
