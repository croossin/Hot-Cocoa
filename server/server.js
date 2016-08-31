var express = require('express');
var request = require('request');
var cheerio = require('cheerio');
var app     = express();
var Q       = require('q');
var MAIN_URL = 'https://www.cocoacontrols.com';


function splitMetaData(str){
  var list = [];
  var temp = str.split(" \u2022 ");
  list.push(temp[0]);
  list.push(temp[1].split(" ")[0]);
  return list
}

function getDetails(controlUrl){
  url = MAIN_URL + controlUrl;

  var p = Q.defer();

  //Get details on specific control
  request(url, function(error, response, html){
    if(!error && response.statusCode == 200){
      var $ = cheerio.load(html);

      d = {};

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
    }

    p.reject(error);
  })

  return p.promise;
}

app.get('/', function(req, res){
  
  url = MAIN_URL;

  request(url, function(error, response, html){
    if(!error && response.statusCode == 200){
      var $ = cheerio.load(html);

      var controls = [];
      var promises = [];

      $('li.block-grid-item').each(function(i, element){

        var cn = $(this).children().next().find('a').text();
        var cu = $(this).find('p > a').attr('href');
        var ci = $(this).find('p > a > img').attr('src');

        var t = splitMetaData($(this).find('p.control-metadata').text());
        var dateAdded = t[0];
        var license = t[1];

        promises.push(getDetails(cu));

        controls.push({"name": cn, "url": cu, "imageUrl": ci, "dateAdded": dateAdded, "license": license});
      })

      Q.all(promises).then(function(results){
        for(i = 0; i < results.length; i++){
          controls[i].details = results[i];
        }
        res.send(controls);
      });
    }
  })
})


app.listen('8081')
console.log('Magic happens on port 8081');
exports = module.exports = app;
