var express  = require('express');
var app      = express();
var morgan   = require('morgan');
var mongoose = require('mongoose');
var uuid     = require('node-uuid');

/** 
 * =============================================================================
 * Config Variables
 * =============================================================================
 */
// var MAIN_URL = 'https://www.cocoacontrols.com';


// /** 
//  * =============================================================================
//  * Mongo Database
//  * =============================================================================
//  */
// mongoose.connect('mongodb://localhost/hotcocoa');
// mongoose.Promise = global.Promise;
// var db = mongoose.connection;
// db.on('error', console.error.bind(console, 'connection error:'));
// db.once('open', function() {
//     console.log("Connected to DB");
// });

// var Schema = mongoose.Schema;

// var cocoaSchema = new Schema({
//   name: String,
//   url: String,
//   imageUrl: String,
//   dateAddedPretty: String,
//   dateAdded: Date,
//   license: String,
//   details: {
//     amountOfVotes: String,
//     appetize: String,
//     tags: [String],
//     license: String,
//     language: String,
//     githubLink: String,
//     description: String
//   }
// });

// var CocoaPod = mongoose.model('CocoaPod', cocoaSchema);

// Tracking
app.use(morgan(':method :url :response-time'));

// Routes
app.use('/api/v1/search', require('./api/v1/search'));
app.use('/api/v1/author', require('./api/v1/author'));


app.listen('8081')
console.log('Magic happens on port 8081');
exports = module.exports = app;
