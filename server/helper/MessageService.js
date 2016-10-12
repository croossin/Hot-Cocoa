/** 
 * =============================================================================
 * Imports
 * =============================================================================
 */
var Message  = require('../helper/messageModel.js');
var Q        = require('q');

exports.getMessagesInRoom = function(roomname){
	var p = Q.defer();
	
	Message.find({'chatRoom': roomname})
	.then(function(messages){
		p.resolve(messages); 
	}, function(err){
		p.reject([]);
	})

	return p.promise;
}

exports.saveMessage = function(room, nickname, message){
	var newMessage = new Message();
	
	newMessage.chatRoom = room;
	newMessage.senderID = nickname;
	newMessage.senderDisplayName = nickname
	newMessage.message = message;

	newMessage.save();

	return newMessage; 
}