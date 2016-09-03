'use strict';
/** 
 * =============================================================================
 * Imports
 * =============================================================================
 */
var express = require('express');
var controller = require('./controller');
var router = express.Router();

/** 
 * =============================================================================
 * Routes
 * =============================================================================
 */
//Get most recent pods
router.post('/fetch', controller.fetch);

//Get by rating
router.post('/fetch/rating', controller.fetchRating);

//Get by language
router.post('/fetch/language/:language?', controller.fetchLanguage);

//Get by license
// router.post('/fetch/license/:license?', controller.fetchLicense);

module.exports = router;