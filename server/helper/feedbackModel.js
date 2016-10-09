var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var feedbackSchema = new Schema({
  email: String,
  topic: String,
  note: String,
  device: String,
  iOS: String,
  version: String,
  build: String,
  date: {
    type: Date,
    default: new Date()
  }
});

module.exports = mongoose.model('Feedback', feedbackSchema);