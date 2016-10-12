var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var messageSchema = new Schema({
  chatRoom: String,
  senderID: String,
  senderDisplayName: String,
  composedDate: {
    type: Date,
    default: new Date()
  },
  message: String,
  isMedia: Boolean
});

module.exports = mongoose.model('Message', messageSchema);