var express  = require('express');
var request  = require('request');
var cheerio  = require('cheerio');
var app      = express();
var Q        = require('q');
var mongoose = require('mongoose');

/** 
 * =============================================================================
 * Config Variables
 * =============================================================================
 */
// var MAIN_URL = 'https://www.cocoacontrols.com';


// /** 
//  * =============================================================================
//  * Mongo Database
//  * =============================================================================
//  */
// mongoose.connect('mongodb://localhost/hotcocoa');
// mongoose.Promise = global.Promise;
// var db = mongoose.connection;
// db.on('error', console.error.bind(console, 'connection error:'));
// db.once('open', function() {
//     console.log("Connected to DB");
// });

// var Schema = mongoose.Schema;

// var cocoaSchema = new Schema({
//   name: String,
//   url: String,
//   imageUrl: String,
//   dateAddedPretty: String,
//   dateAdded: Date,
//   license: String,
//   details: {
//     amountOfVotes: String,
//     appetize: String,
//     tags: [String],
//     license: String,
//     language: String,
//     githubLink: String,
//     description: String
//   }
// });

// var CocoaPod = mongoose.model('CocoaPod', cocoaSchema);


// /** 
//  * =============================================================================
//  * Helper Functions
//  * =============================================================================
//  */
// function splitMetaData(str){
//   var list = [];
//   var temp = str.split(" \u2022 ");
//   list.push(temp[0]);
//   list.push(temp[1].split(" ")[0]);
//   return list
// }

// function getDetails(controlUrl){
//   url = MAIN_URL + controlUrl;

//   var p = Q.defer();

//   //Get details on specific control
//   request(url, function(error, response, html){
//     if(!error && response.statusCode == 200){
//       var $ = cheerio.load(html);

//       d = {};

//       //Amount of Votes
//       d.amountOfVotes = $('span.ratings-count').text().split(" ")[0];
      
//       //Appetize
//       if($('div.featured-control-image').find('iframe').attr('src')){
//         d.appetize = $('div.featured-control-image').find('iframe').attr('src');
//       }

//       //Tags
//       d.tags = [];

//       $('li.tag').each(function(i, element){
//         if($(this).text() !== ""){
//           d.tags.push($(this).text().replace(/(\r\n|\n|\r)/gm,""));
//         }
//       })

//       //GH Info
//       $('#github_info').find('dd').each(function(i, element){
//         if(i === 0){
//           d.license = $(this).text();
//         }
//         if(i === 1){
//           d.language = $(this).text();
//         }
//       })

//       //GH Link
//       d.githubLink = $('#get_source_link').attr('href'); 

//       //Description
//       d.description = $('div.rendered-description').children().first().text();

//       p.resolve(d);
//     }

//     p.reject(error);
//   })

//   return p.promise;
// }

// function getPageData(page, res){

//     url = (page == 1 || page == 0) ? MAIN_URL : (MAIN_URL + '/controls?page=' + page)
    
//     console.log("Getting data for URL: " + url);

//     request(url, function(error, response, html){
//       if(!error && response.statusCode == 200){
//         var $ = cheerio.load(html);

//         var controls = [];
//         var promises = [];

//         $('li.block-grid-item').each(function(i, element){

//           var cn = $(this).children().next().find('a').text();
//           var cu = $(this).find('p > a').attr('href');
//           var ci = $(this).find('p > a > img').attr('src');

//           var t = splitMetaData($(this).find('p.control-metadata').text());
//           var dateAddedPretty = t[0];
//           var dateAdded = new Date(t[0]);
//           var license = t[1];

//           promises.push(getDetails(cu));

//           controls.push({"name": cn, "url": cu, "imageUrl": ci, "dateAdded": dateAdded , "dateAddedPretty": dateAddedPretty, "license": license});
//         })

//         Q.all(promises).then(function(results){
//           for(i = 0; i < results.length; i++){
//             controls[i].details = results[i];
//           }
//           res.send(controls);
//         });
//       }
//     }) 
// }

// /** 
//  * =============================================================================
//  * API Routes
//  * =============================================================================
//  */
// app.get('/:numberOfPods?', function(req, res){
//     if(req.params.numberOfPods){
//       CocoaPod.find().limit(30).exec(function(err, posts){
//           res.send(posts);
//       });
//     }else{ 
//     }
// })

app.use('/api/v1/search', require('./api/v1/search'));
app.use('/api/v1/author', require('./api/v1/author'));


app.listen('8081')
console.log('Magic happens on port 8081');
exports = module.exports = app;
