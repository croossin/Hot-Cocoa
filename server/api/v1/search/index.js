'use strict';

/** 
 * =============================================================================
 * Imports
 * =============================================================================
 */
var express = require('express');
var controller = require('./search.controller');
var router = express.Router();

/** 
 * =============================================================================
 * Routes
 * =============================================================================
 */
router.post('/:searchTerm', controller.search);
router.get('/fuzzySearch/:searchTerm', controller.fuzzySearch);

module.exports = router;