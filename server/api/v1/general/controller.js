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
 * Public Function
 * =============================================================================
 */
exports.fetch = function(req, res){

	var skipNumber = req.body.currentNumber;
	
	Pod.find()
	.limit(20)
	.skip(skipNumber)
	.sort('-dateAdded')
	.then(function(resp){
		res.send(resp);
	}, function(err){
		res.send(err);
	})
}

exports.fetchRating = function(req, res){
	var skipNumber = req.body.currentNumber;

	Pod.find()
	.limit(20)
	.skip(skipNumber)
	.sort({'dateAdded': 1, 'details.amountOfVotes': 1})
	.then(function(resp){
		res.send(resp);
	}, function(err){
		res.send(err);
	})
}

exports.fetchLanguage = function(req, res){
	var skipNumber = req.body.currentNumber;

	var language = req.params.language === 'swift' ? 'Swift' : 'Objective-C';

	Pod.find({'details.language' : language})
	.limit(20)
	.skip(skipNumber)
	.sort('-dateAdded')
	.then(function(resp){
		res.send(resp);
	}, function(err){
		res.send(err);
	})	
}

exports.fetchLicense = function(req, res){
	var skipNumber = req.body.currentNumber;

	//NEED TO FIX
	var license = req.params.license === 'MIT' ? 'MIT' : 'Objective-C';

	Pod.find({'license' : license})
	.limit(20)
	.skip(skipNumber)
	.sort('-dateAdded')
	.then(function(resp){
		res.send(resp);
	}, function(err){
		res.send(err);
	})
}