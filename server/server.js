var express    = require('express');
var app        = express();
var morgan     = require('morgan');
var mongoose   = require('mongoose');
var bodyParser = require('body-parser');
var server = require('http').createServer(app);
var io = require('socket.io')(server);

/** 
 * =============================================================================
 * Mongo Database
 * =============================================================================
 */
// mongoose.connect(process.env.MONGODB_URI);
mongoose.connect("mongodb://localhost/hotcocoa")

mongoose.Promise = global.Promise;

var db = mongoose.connection;

db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', function() {
    console.log("Connected to DB");
});

/** 
 * =============================================================================
 * Socket Config
 * =============================================================================
 */
io.on('connection', function(clientSocket){
  console.log('User connected');

  	clientSocket.on('disconnect', function(){
    	console.log('User disconnected');

	});
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
app.use(morgan(':method :url :status :res[content-length] - :response-time ms'));

/** 
 * =============================================================================
 * Routes
 * =============================================================================
 */
app.use('/api/v1/search', require('./api/v1/search'));
app.use('/api/v1/author', require('./api/v1/author'));
app.use('/api/v1/feedback', require('./api/v1/feedback'));
app.use('/api/v1', require('./api/v1/general'));

/** 
 * =============================================================================
 * Final Setup
 * =============================================================================
 */

// app.listen(process.env.PORT || '8081');
server.listen('8081');
console.log('Magic happens on port ');
exports = module.exports = app;
