'use strict';
/** 
 * =============================================================================
 * Imports
 * =============================================================================
 */
var scraper   = require('../../../helper/scraper.js');
var formatter = require('../../../helper/formatter.js');
var config    = require('../../../config.js');
var Pod  = require('../../../helper/cocoaModel.js');

/** 
 * =============================================================================
 * Public Functions
 * =============================================================================
 */
exports.search = function(req, res){
	
	var skipNumber = req.body.currentNumber;

	console.log(skipNumber);

	Pod.find({'details.tags': req.params.searchTerm})
	.limit(20)
	.skip(skipNumber)
	.sort('-details.amountOfVotes')	
	.then(function(resp){
		res.send(resp);
	}, function(err){
		res.send(err);
	})
}

//This is for when the user is typing in search field
//and we want to prepoulate assumptions
exports.fuzzySearch = function(req, res){

	var searchTerm = req.params.searchTerm;

	Pod.find({'details.tags': {'$regex': searchTerm, '$options': 'i'}})
	.limit(10)
	.then(function(resp){
		res.send(resp);
	}, function(err){
		res.send(err);
	})
}

exports.fuzzySearchTags = function(req, res){

	var searchTerm = req.params.searchTerm;

	Pod.find({'details.tags': {'$regex': '^' + searchTerm}}, 'details.tags')
	.then(function(pods){
		
		var listOfTags = [];

		//Iterate through all pods that have tags like that
		for(var i = 0; i < pods.length; i++){
			var tags = pods[i].details.tags;
			
			//Iterate through each pods tags and add the ones that are similar
			for(var x = 0; x < tags.length; x++){

				//Make sure it starts with search term and that it is not already in list
				if(tags[x].startsWith(searchTerm) && (listOfTags.indexOf(tags[x]) == -1)){
					listOfTags.push(tags[x]);
				}
			}
		}

		res.send(listOfTags);
	}, function(err){
		res.send(err);
	})
}