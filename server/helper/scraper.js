'use strict';

/** 
 * =============================================================================
 * Imports
 * =============================================================================
 */
var request  = require('request');
var cheerio  = require('cheerio');
var Q        = require('q');
var config   = require('../config.js')
/** 
 * =============================================================================
 * Exported Functions
 * =============================================================================
 */
module.exports = {

	//Called to scrape a single url
	getFullPageAndDetail: function(givenUrl){

		var p = Q.defer();

	    request(givenUrl, function(error, response, html){
	      if(!error && response.statusCode == 200){
	        var $ = cheerio.load(html);

	        var controls = [];
	        var promises = [];

	        $('li.block-grid-item').each(function(i, element){

	          var cn = $(this).children().next().find('a').text();
	          var cu = $(this).find('p > a').attr('href');
	          var ci = $(this).find('p > a > img').attr('src');

	          var t = splitMetaData($(this).find('p.control-metadata').text());
	          var dateAddedPretty = t[0];
	          var dateAdded = new Date(t[0]);
	          var license = t[1];

	          promises.push(getDetails(cu));

	          controls.push({"name": cn, "url": cu, "imageUrl": ci, "dateAdded": dateAdded , "dateAddedPretty": dateAddedPretty, "license": license});
	        })

	        Q.all(promises).then(function(results){
	          for(var i = 0; i < results.length; i++){
	            controls[i].details = results[i];
	          }
	          p.resolve(controls);
	        });
	      }else{
	      	p.reject(error);
	      }
	    })

	    return p.promise; 
	},

  getCocoaPodsOrgDetails: function(podUrl){
    var p = Q.defer();

    var url = config.COCOAPODS_MAINURL + podUrl;

    //Fetch detailed pod pages and scrape for data
    request(url, function(error, response, html){
    if(!error && response.statusCode == 200){

      var $ = cheerio.load(html);

      var d = {};

      //Get Header information
      var t = $('table.header').children();

      d.language = t.children().last().prev().prev().children().last().children().last().text();
      var license = t.children().last().prev().children().last().text();
      d.license = license.replace(/\s/g, "");
      d.lastRelease = t.children().last().children().last().text();

      //Iterate the main data blocks
      $('table.inset').each(function(i, element){
          
          //Downloads
          if(i === 0){
            var downloads = {};
            var t = $(this).find('tbody').children();
            
            downloads.total = t.first().children().next().text();
            downloads.week = t.next().children().first().next().text();
            downloads.month = t.last().children().next().text();
            
            d.downloads = downloads;
          }

          //Installs
          else if(i === 1){
            var installs = {};
            var t = $(this).find('tbody').children();

            installs.apps = t.first().children().next().text();
            installs.appsThisWeek = t.next().children().first().next().text();
            installs.podTries = t.next().next().children().first().next().text();
          
            d.installs = installs;
          }

          //GitHub
          else if(i === 2){
            var github = {};
            var t = $(this).find('tbody').children();
            
            github.stars = t.first().children().next().text();
            github.watchers = t.next().children().first().next().text();
            github.forks = t.next().next().children().first().next().text();
            github.issues = t.next().next().next().children().first().next().text();
            github.contributors = t.next().next().next().next().children().first().next().text();
            github.pullRequests = t.last().children().first().next().text();

            d.github = github;
          }

          //Code Base
          else if(i === 3){
            var codebase = {};
            var t = $(this).find('tbody').children();

            codebase.files = t.first().children().next().text();
            codebase.size = t.next().children().first().next().text();
            codebase.linesOfCode = t.last().children().next().text();

            d.codebase = codebase;          
          }
      })

      p.resolve(d);
    }else{
      p.reject(error);
    }
  })

    return p.promise;
  }
}

/** 
 * =============================================================================
 * Helper Functions
 * =============================================================================
 */
function splitMetaData(str){
  var list = [];
  var temp = str.split(" \u2022 ");
  list.push(temp[0]);
  list.push(temp[1].split(" ")[0]);
  return list
}

function getDetails(controlUrl){
  var url = config.MAIN_URL + controlUrl;

  var p = Q.defer();

  //Get details on specific control
  request(url, function(error, response, html){
    if(!error && response.statusCode == 200){
      var $ = cheerio.load(html);

      var d = {};
      var author = {};

      //Author
      author.name = $('small').find('a').text();
      author.url = $('small').find('a').attr('href');
      author.image = $('small').find('a > img').attr('src');

      d.author = author;

      //Amount of Votes
      d.amountOfVotes = $('span.ratings-count').text().split(" ")[0];
      
      //Appetize
      if($('div.featured-control-image').find('iframe').attr('src')){
        d.appetize = $('div.featured-control-image').find('iframe').attr('src');
      }

      //Tags
      d.tags = [];

      $('li.tag').each(function(i, element){
        if($(this).text() !== ""){
          d.tags.push($(this).text().replace(/(\r\n|\n|\r)/gm,""));
        }
      })

      //GH Info
      $('#github_info').find('dd').each(function(i, element){
        if(i === 0){
          d.license = $(this).text();
        }
        if(i === 1){
          d.language = $(this).text();
        }
      })

      //GH Link
      d.githubLink = $('#get_source_link').attr('href'); 

      //Description
      d.description = $('div.rendered-description').children().first().text();

      p.resolve(d);
    }else{
      p.reject(error);
    }
  })

  return p.promise;
}