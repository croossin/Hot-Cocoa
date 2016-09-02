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
	var skipNumber = req.params.fromPage ? req.params.fromPage : 0;

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