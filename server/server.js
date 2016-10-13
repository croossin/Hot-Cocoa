var express    = require('express');
var app        = express();
var morgan     = require('morgan');
var mongoose   = require('mongoose');
var bodyParser = require('body-parser');
var server = require('http').createServer(app);
var io = require('socket.io')(server);
var MessageService = require('./helper/MessageService.js');
var RoomService = require('./helper/RoomService.js');

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

  	clientSocket.on('connectUserToRoom', function(room, nickname){
   		console.log(nickname + " is trying to connect to: " + room);

   		//Grab messages from DB
   		MessageService.getMessagesInRoom(room)
   		.then(function(messages){

   			//Return messages that are in the room
   			io.emit(room + "/messages", messages);
   		});

   		//Get list of current active users
   		RoomService.addSelfAsConnectedUsersInRoom(room, nickname)
   		.then(function(users){

   			io.emit(room +"/users", users);
   		});

   		//Typing Status - Start
   		clientSocket.on(room +'/startType', function(room, nickname){

   			RoomService.addTypingUserInRoom(room, nickname)
   			.then(function(typingList){

   				io.emit(room + "/typingUpdate", typingList);
	   		});
   		});

		//Typing Status - End
		clientSocket.on(room +'/endType', function(room, nickname){

   			RoomService.removeTypingUserInRoom(room, nickname)
   			.then(function(typingList){
   				console.log(typingList);
   				io.emit(room + "/typingUpdate", typingList);
	   		});
   		});

	   	//Got message
		clientSocket.on(room + '/chatMessage', function(room, nickname, message){
			console.log("Got a message from " + nickname + " in room: " + room + "\n" + message);

			var message = MessageService.saveMessage(room, nickname, message);

			io.emit(room + "/newChatMessage", message);
		});   		
	});

  	//Disconnected from room
	clientSocket.on('disconnectUserFromRoom', function(room, nickname){
   		console.log(nickname + " is disconnecting from: " + room);

   		//Remove from DB
   		RoomService.removeConnectedUserInRoom(room, nickname)
   		.then(function(users){
   			io.emit(room + "/users", users);
   		});
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

// server.listen(process.env.PORT || '8081');
server.listen('8081');
console.log('Magic happens on port ');
exports = module.exports = app;
