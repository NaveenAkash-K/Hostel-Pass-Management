const mongoose = require('mongoose');

const announcementSchema = mongoose.Schema({
    title:{type:String,required:true},
    message:{type:String,required:true},
    rtId:{type:String,required:true},
    blockNo:{type:Number,required:true},
    isRead:{type:Boolean,required:true,default:false},
    isBoysHostelRt:{type:Boolean,required:true}
})

module.exports = mongoose.model('announcement',announcementSchema);