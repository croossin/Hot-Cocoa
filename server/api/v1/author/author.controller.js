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
	
	Pod.find({'details.author.name': req.params.author})
	.then(function(resp){
		res.send(resp);
	}, function(err){
		res.send(err);
	})
}