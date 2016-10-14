/** 
 * =============================================================================
 * Imports
 * =============================================================================
 */
var Room  = require('../helper/roomModel.js');
var Q        = require('q');

exports.addTypingUserInRoom = function(roomname, nickname){
	var p = Q.defer();
	
	Room.findOne({'chatRoom': roomname})
	.then(function(room){
		if(room !== null){
			if(room.typingList.indexOf(nickname) === -1){
				room.typingList.push(nickname);
				room.save();
				p.resolve(room.typingList); 
			}else{
				p.resolve(room.typingList);
			}
		}else{
			var newRoom = new Room();
			newRoom.chatRoom = roomname;
			newRoom.typingList = [];
			newRoom.typingList.push(nickname);
			newRoom.save();
			p.resolve(newRoom.typingList);
		}
	}, function(err){
		p.reject([]);
	})

	return p.promise;
}

exports.removeTypingUserInRoom = function(roomname, nickname){
	var p = Q.defer();
	
	Room.findOne({'chatRoom': roomname})
	.then(function(room){
		var index = room.typingList.indexOf(nickname);
		if (index !== -1) {
		    room.typingList.splice(index, 1);
		    room.save();
		    p.resolve(room.typingList);
		}
	}, function(err){
		p.reject([]);
	})

	return p.promise;
}

exports.getTypingUsersInRoom = function(roomname){
	var p = Q.defer();
	
	Room.findOne({'chatRoom': roomname})
	.then(function(room){
		p.resolve(room.typingList); 
	}, function(err){
		p.reject([]);
	})

	return p.promise;
}

exports.addSelfAsConnectedUsersInRoom = function(roomname, nickname){
	var p = Q.defer();
	
	Room.findOne({'chatRoom': roomname})
	.then(function(room){
		if(room !== null){
			if(room.connectedUserList.indexOf(nickname) === -1){
				room.connectedUserList.push(nickname);
				room.save();
				p.resolve(room.connectedUserList); 
			}else{
				p.resolve(room.connectedUserList);
			}
		}else{
			var newRoom = new Room();
			newRoom.chatRoom = roomname;
			newRoom.connectedUserList = [nickname];
			newRoom.save();
			p.resolve(newRoom.connectedUserList);
		}
	}, function(err){
		console.log("error getting connected user");
		p.reject([]);
	})

	return p.promise;
}

exports.removeConnectedUserInRoom = function(roomname, nickname){
	var p = Q.defer();

	Room.findOne({'chatRoom': roomname})
	.then(function(room){
		var indexOfConnected = room.connectedUserList.indexOf(nickname);
		var indexOfTyping = room.typingList.indexOf(nickname);
		if (indexOfConnected !== -1) {
		    room.connectedUserList.splice(indexOfConnected, 1);
			
			if (indexOfTyping !== -1){
				room.typingList.splice(indexOfTyping, 1);
			}
		    
		    room.save();
		    p.resolve(room.connectedUserList);
		}
	}, function(err){
		p.reject([]);
	})

	return p.promise;
}

exports.removeFromEntireDB = function(nickname){
	var p = Q.defer();

	Room.update({}, {$pull: {"connectedUserList": nickname, 'typingList': nickname}}, {multi: true})
	.then(function(room){
		p.resolve();
	}, function(err){
		p.reject();
	})

	return p.promise;
}