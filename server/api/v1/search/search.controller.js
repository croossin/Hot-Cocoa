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

	//TODO NEED TO FIX FOR BODY REQUESTS
	// var skipNumber = req.params.fromPage ? req.params.fromPage : 0;

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