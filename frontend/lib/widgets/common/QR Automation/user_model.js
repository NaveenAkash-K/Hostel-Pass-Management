const mongoose = require("mongoose");

const schema = new mongoose.Schema({
  username: {
    type: String,
    required: true,
  },
  email: {
    type: String,
    required: true,
  },
  phoneNo: {
    type: String,
    required: false,
  },
  regNo: {
    type: String,
    required: true,
  },
  college: {
    type: String,
    required: true,
  },
  year: {
    type: String,
    required: true,
  },
  pass: {
    type: String,
    required: true,
  },
  ordId: {
    type: String,
    required: true,
  },
});

const User = mongoose.model("User", schema);

module.exports = User;
