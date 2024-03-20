const mongoose = require("mongoose");
const schema = mongoose.Schema;

const SecuritySchema = new schema(
  {
    securityId: {
      type: String,
      required: true,
    },
    username: {
      type: String,
      required: true,
    },
    email: {
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
  },
  { timestamps: true }
);

module.exports = mongoose.model("security", SecuritySchema);
