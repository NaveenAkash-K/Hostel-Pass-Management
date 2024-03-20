const mongoose = require("mongoose");
const schema = mongoose.Schema;

const StudentSchema = new schema(
  {
    studentId: {
      type: String,
      required: true,
    },
    username: {
      type: String,
      required: true,
    },
    gender: {
      type: String,
      required: true,
      emum: ["M", "F"],
    },
    regNo: {
      type: String,
      required: true,
    },
    uid: {
      type: String,
      required: true,
    },
    phNo: {
      type: String,
      required: true,
    },
    fatherName: {
      type: String,
      required: true,
    },
    motherName: {
      type: String,
      required: true,
    },
    fatherPhNo: {
      type: String,
      required: true,
    },
    motherPhNo: {
      type: String,
      required: true,
    },
    dept: {
      type: String,
      required: true,
    },
    year: {
      type: Number,
      required: true,
    },
    section: {
      type: String,
      required: true,
    },
    blockNo: {
      type: Number,
      required: true,
    },
    roomNo: {
      type: Number,
      required: true,
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("students", StudentSchema);
