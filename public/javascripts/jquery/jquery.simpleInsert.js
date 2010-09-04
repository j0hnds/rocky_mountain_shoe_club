/**
* SIMPLE INSERT PLUGIN
* -----------------------------------------------
* Plugin to insert content on the page via AJAX. Built
* to work with $.simpleSpinner() and $.simpleConfirm()
* or independently
*
* Example Use
*	-----------------------------------------------
* $('#myLink').click(function(event){
* 	$.simpleInsert({
*			block_event : event,
*			target : '#myDiv',
*			source : this.href,
*			callback : function(){alert('Loaded!');}
*		});
* });
*/

(function($){

	// Load required resources
	if(!$.blockUI){$.require('jquery/jquery.blockUI.js');}
	if(!$.simpleConfirm){$.require('jquery/jquery.simpleConfirm.js');}
	if(!$.simpleSpinner){$.require('jquery/jquery.simpleSpinner.js');}

	$.simpleInsert = function(options){

		// Set locals
		var settings = $.extend({}, $.simpleInsert.defaults, options);

		// Block default event
		if(settings.block_event){
			settings.block_event.preventDefault();
		}

		// Content loader
		var loadContent = function(){
			if(settings.use_spinner){
				$.simpleSpinner({message : settings.spinner_message});
			}
			$(settings.target)
				.css('display','none')
				.load(settings.source,function(){
					$(this).fadeIn('fast');
					$.unblockUI();
					settings.callback();
					$("input[type='text']:first:visible:enabled", this).focus();
				});
		};

		// Load content
		if(settings.confirm_insert){
			$.simpleConfirm({
				message : settings.confirm_message,
				proceed_button : settings.confirm_proceed_button,
				cancel_button : settings.confirm_cancel_button,
				proceed_callback : loadContent,
				cancel_callback : settings.confirm_cancel_callback
			});
		} else {
			loadContent();
		}

	};

	// Set defaults
	$.simpleInsert.defaults = {
		block_event : false,
		target : false,
		source : false,
		callback : function(){},

		// Spinner defaults
		use_spinner : false,
		spinner_message : 'Loading...',
		
		// Confirmation defaults
		confirm_insert : false,
		confirm_message : 'Are you sure?',
		confirm_proceed_button : 'Yes, proceed!',
		confirm_cancel_button : 'Cancel',
		confirm_cancel_callback : function(){}
	};

})(jQuery);