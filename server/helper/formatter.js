'use strict';

module.exports = {
	formatUrl: function(request){
		return request.split(' ').join('+');
	}
};