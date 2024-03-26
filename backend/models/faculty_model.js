const mongoose = require("mongoose");
const schema = mongoose.Schema;
const { v4: uuidv4 } = require("uuid");

const FacultySchema = new schema(
  {
    facultyId: {
      type: String,
      required: true,
      default: "faculty_" + uuidv4(),
    },
    uid: {
      type: String,
      required: true,
    },
    username: {
      type: String,
      required: true,
    },
    email: {
      type: String,
    },
    phNo: {
      type: String,
      required: true,
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("faculty", FacultySchema);
