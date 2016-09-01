'use strict';

var express = require('express');
var controller = require('./search.controller');
var router = express.Router();

router.post('/:searchTerm', controller.search);

module.exports = router;