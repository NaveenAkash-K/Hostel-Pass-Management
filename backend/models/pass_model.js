const mongoose = require("mongoose");
const schema = mongoose.Schema;

const PassSchema = new schema(
  {
    passId: {
      type: String,
      required: true,
    },
    uid: {
      type: String,
      required: true,
    },
    studentId: {
      type: String,
      required: true,
    },
    type: {
      type: String,
      required: true,
      emum: ["Gatepass", "Staypass"],
    },
    reason: {
      type: String,
      required: true,
    },
    status: {
      type: String,
      required: true,
      enum: ["Pending", "Approved", "Rejected", "Used", "In use"],
    },
    destination: {
      type: String,
      required: true,
    },
    isActive: {
      type: Boolean,
      required: true,
    },
    approvedBy: {
      type: String,
      required: true,
      default:"None"
    },
    confirmedWith: {
      type: String,
      required: true,
      default:"None"
    },
    scannedBy: {
      type: String,
    },
    expectedOutTime: {
      type: String,
      required: true,
    },
    actualOutTime: {
      type: String,
    },
    expectedInTime: {
      type: String,
      required: true,
    },
    actualInTime: {
      type: String,
    },
    expectedOutDate: {
      type: String,
      required: true,
    },
    actualOutDate: {
      type: String,
    },
    expectedInDate: {
      type: String,
      required: true,
    },
    actualInDate: {
      type: String,
    },
    isEntryLate: {
      type: Boolean,
    },
    lateReason: {
      type: String,
    },
    qrId: {
      type: String,
      required: true,
    },
    isSpecialPass: {
      type: Boolean,
      required: true,
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("passes", PassSchema);
