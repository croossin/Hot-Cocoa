'use strict';
/** 
 * =============================================================================
 * Imports
 * =============================================================================
 */
var express = require('express');
var controller = require('./author.controller');
var router = express.Router();

/** 
 * =============================================================================
 * Routes
 * =============================================================================
 */
router.get('/:author', controller.search);

module.exports = router;