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
var Q        = require('q');
var http = require('http');

/** 
 * =============================================================================
 * Public Functions
 * =============================================================================
 */

//We got a tag search:
//* Scan cocoapods.org
//* Get top 10 most popular
//* Scrape each of their pages
//* Return array of objects
exports.searchTag = function(req, res){
	
	var skipNumber = req.body.currentNumber;
	var searchTerm = req.params.searchTerm;

	//Make CocoaPods.org API call to retrieve the 10 they think we should scrape
	var options = {
		host: config.COCOAPODS_APIURL,
		path: '/api/pods?query=' + searchTerm,
		headers: {
			accept: 'application/vnd.cocoapods.org+flat.hash.json'
		}
	};

	// scraper.getCocoaPodsOrgDetails('RETableViewManager');

	http.get(options, function(cocoaRes) {
	  
	  if(cocoaRes.statusCode === 200){

  		  var data = '';

		  cocoaRes.on('data', function(chunk){
		  	data += chunk;
		  });

		  cocoaRes.on('end', function(){
		  	var jsonData = JSON.parse(data);
		   	
		   	var pods = [];
		   	var promises = [];
		   	
		   	//Iterate through each response
		   	for(var i = 0; i < jsonData.length; i++){
		   		var currentPod = jsonData[i];

		   		//Add the detail scrape promise to array of promises
		   		// promises.push(scraper.getCocoaPodsOrgDetails(currentPod.id));

		   		pods.push({
		   			"name": currentPod.id,
		   			"version": currentPod.version,
		   			"description": currentPod.summary,
		   			"url": currentPod.link,
		   			"documentation": currentPod.cocoadocs,
		   			"tags": currentPod.tags,
		   			"author":{
		   				"name": Object.keys(currentPod.authors)[0],
		   				"author": currentPod.authors[Object.keys(currentPod.authors)[0]]
		   			}
		   		});
		   	}

		   	//Iterate through all final promises and append to pods
		   	Q.all(promises).then(function(results){

	          for(i = 0; i < results.length; i++){

	          	//Add all details we gathered from their page to the object
	            pods[i].details = results[i];
	          }

	          //Send back entire object
	          res.send(pods);
	        });
		  });
	  }else{
	  	res.send("Bad Network Request.");
	  }
	}).on('error', function(e) {
	  console.log("Got error: " + e.message);
	  res.send("Bad Network Request.");
	});
	//Once we have the 10, scrape each individual pods page
	
	//Return a compiled array of objects
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