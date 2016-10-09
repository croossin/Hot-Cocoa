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
router.post('/', controller.postFeedback);

module.exports = router;