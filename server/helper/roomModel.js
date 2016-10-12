var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var roomSchema = new Schema({
  chatRoom: String,
  typingList: [String],
  connectedUserList: [String]
});

module.exports = mongoose.model('Room', roomSchema);