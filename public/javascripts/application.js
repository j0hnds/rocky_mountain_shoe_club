// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(function(){

	// Set up date picker fields
	$('.date_picker').livequery(function(){
		// Load required resources
		if(!$.fn.datepicker) {
			$.require('jquery/jqueryui.core.js');
			$.require('jquery/jqueryui.datepicker.js');
		}
		$('.date_picker').datepicker({dateFormat: 'yy-mm-dd'});
	});

});

/*
	REQUIRE PLUGIN
	-----------------------------------
	if(!$.fn.skipLogic){$.require('jquery/jquery.skipLogic.js');}
*/

(function($){

	$.require = function(resource){

		$('<script/>')
			.attr({
				src : '/javascripts/'+resource,
				type : 'text/javascript'
			})
			.appendTo('head');
	};

})(jQuery);