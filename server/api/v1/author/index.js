'use strict';

var express = require('express');
var controller = require('./author.controller');
var router = express.Router();

router.post('/:author', controller.search);

module.exports = router;