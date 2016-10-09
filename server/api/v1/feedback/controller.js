'use strict';
/** 
 * =============================================================================
 * Imports
 * =============================================================================
 */
var Feedback  = require('../../../helper/feedbackModel.js');

/** 
 * =============================================================================
 * Public Function
 * =============================================================================
 */
exports.postFeedback = function(req, res){
	var newFeedback = new Feedback();

	var email = req.body.email;
	var topic = req.body.topic;
	var content = req.body.content;

	newFeedback.email = email;
	newFeedback.topic = removeColon(topic);

	var tempArray = new Array();
	tempArray = content.split("\n");

	newFeedback.note = tempArray[0];
	newFeedback.device = removeColon(tempArray[3]);
	newFeedback.iOS = removeColon(tempArray[4]);
	newFeedback.version = removeColon(tempArray[6]);
	newFeedback.build = removeColon(tempArray[7]);

	newFeedback.save()
	.then(function(resp){
		res.send(resp);
	}, function(err){
		res.send(err);
	})
}

function removeColon(input){
	return input.substring(input.indexOf(":") + 2, input.length); 
}