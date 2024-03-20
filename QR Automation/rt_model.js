const mongoose = require("mongoose");
const schema = mongoose.Schema;
const { v4: uuidv4 } = require("uuid");

const RtSchema = new schema(
  {
    rtId: {
      type: String,
      required: true,
      default: "rt_" + uuidv4(),
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
    permanentBlock: {
      type: Number,
      required: true,
    },
    temporaryBlock: {
      type: Array,
      default: [],
      required: false,
    },
    phNo: {
      type: String,
      required: true,
    },
    isBoysHostelRt:{
      type:Boolean,
      required:true,
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("rts", RtSchema);
