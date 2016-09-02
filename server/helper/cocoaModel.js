var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var cocoaSchema = new Schema({
  name: String,
  url: String,
  imageUrl: String,
  dateAddedPretty: String,
  dateAdded: Date,
  license: String,
  details: {
    amountOfVotes: String,
    appetize: String,
    tags: [String],
    license: String,
    language: String,
    githubLink: String,
    description: String
  }
});

module.exports = mongoose.model('CocoaPod', cocoaSchema);