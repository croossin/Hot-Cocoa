'use strict';

var scraper   = require('../../../helper/scraper.js');
var formatter = require('../../../helper/formatter.js');
var config    = require('../../../config.js');

exports.search = function(req, res){
	var searchURL = config.SEARCH_URL + formatter.formatUrl(req.body.searchTerm); 

	scraper.getFullPageAndDetail(searchURL).then(function(response){
		res.send(response);
	});
}