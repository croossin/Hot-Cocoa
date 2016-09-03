var express  = require('express');
var app      = express();
var morgan   = require('morgan');
var mongoose = require('mongoose');
var bodyParser = require('body-parser')

/** 
 * =============================================================================
 * Mongo Database
 * =============================================================================
 */
mongoose.connect('mongodb://localhost/hotcocoa');

mongoose.Promise = global.Promise;

var db = mongoose.connection;

db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', function() {
    console.log("Connected to DB");
});

/** 
 * =============================================================================
 * Config
 * =============================================================================
 */
app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json())

/** 
 * =============================================================================
 * Tracking
 * =============================================================================
 */
app.use(morgan(':remote-addr - :remote-user [:date[clf]] ":method :url HTTP/:http-version" :status :res[content-length]'));

/** 
 * =============================================================================
 * Routes
 * =============================================================================
 */
app.use('/api/v1/search', require('./api/v1/search'));
app.use('/api/v1/author', require('./api/v1/author'));
app.use('/api/v1', require('./api/v1/general'));

/** 
 * =============================================================================
 * Final Setup
 * =============================================================================
 */

app.listen('8081')
console.log('Magic happens on port 8081');
exports = module.exports = app;
