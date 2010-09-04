/**
* SIMPLE BUTTON PLUGIN
* -----------------------------------------------
* Plugin to create various button types and apply
* callbacks to them
*
* Example Use
*	-----------------------------------------------
* var myButton = $.simpleButton({
*		value : 'Submit',
*		attr : {
*			title : 'Click to submit'
*		},
*		callback : function(){
*			alert("I've been clicked!");
*		}
*	});
*/

(function($){

	$.simpleButton = function(options){

		// Set locals
		var settings = $.extend({}, $.simpleButton.defaults, options),
				validTypes = {a:1, input:1, button:1, file:1, submit:1, reset:1},
				$button;

		// Create button element
		if(settings.type == 'a'){
			$button = $('<a/>').text(settings.value);
		} else if(settings.type == 'button'){
			$button = $('<button/>').text(settings.value);
		} else {
			settings.type = settings.type || 'button';
			$.extend(true,settings.attr,{type:settings.type, value:settings.value});
			$button = $('<input/>');
		}

		// Return button
		return $button
			.attr(settings.attr)
			.css(settings.css)
			.addClass('button')
			.click(function(event){
				if(settings.block_event){event.preventDefault();}
				if($.blockUI){$.unblockUI();}
				settings.callback();
			});

	};

	// Set defaults
	$.simpleButton.defaults = {
		block_event : true,
		type : false,
		value : 'Ok',
		attr : {},
		css : {margin:'10px 10px 0 0'},
		callback : function(){}
	};

})(jQuery);