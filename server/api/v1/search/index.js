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
router.post('/tags/:searchTerm', controller.searchTag);
router.get('/fuzzySearch/:searchTerm', controller.fuzzySearch);
router.get('/fuzzySearchTags/:searchTerm', controller.fuzzySearchTags);

module.exports = router;