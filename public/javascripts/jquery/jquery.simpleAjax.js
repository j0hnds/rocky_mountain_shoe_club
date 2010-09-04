/**
* SIMPLE AJAX PLUGIN
* -----------------------------------------------
* Plugin to handle AJAX requests independent of an
* element or event. Built to work with $.simpleSpinner()
* and $.simpleConfirm() or independently
*
* Example Use
*	-----------------------------------------------
* $('#myForm').submit(function(event){
* 	$.simpleAjax({
*			block_event : event,
*			url : this.action,
*			dataString : $(this).serialize()
*		});
* });
*/

(function($){

	/* Load required resources */
	if(!$.blockUI){$.require('jquery/jquery.blockUI.js');}
	if(!$.simpleConfirm){$.require('jquery/jquery.simpleConfirm.js');}
	if(!$.simpleSpinner){$.require('jquery/jquery.simpleSpinner.js');}

	$.simpleAjax = function(options){

		// Set locals
		var settings = $.extend({}, $.simpleAjax.defaults, options),
				validMethods = {post:1, get:1},
				validTypes = {script:1, html:1, json:1, text:1, xml:1};


		// Block default event
		if(settings.block_event){
			settings.block_event.preventDefault();
		}

		// Submit data method
		var submitData = function(){
			if(settings.use_spinner){
				$.simpleSpinner({message : settings.spinner_message});
			}
			$.ajax({
				type : settings.method,
				url : settings.url,
				dataType : settings.type,
				data : settings.dataString,
				success : function(data){
					if(settings.target){
						$(settings.target).html(data);
					}
					settings.callback();
					$.unblockUI();
				}
			});
		};

		// Submit data
		if(settings.confirm_action){ // <= With confirmation
			$.simpleConfirm({
				message : settings.confirm_message,
				proceed_button : settings.confirm_proceed_button,
				cancel_button : settings.confirm_cancel_button,
				proceed_callback : submitData,
				cancel_callback : settings.confirm_cancel_callback
			});
		} else { // <= Without confirmation
			submitData();
		}

	};

	// Set defaults
	$.simpleAjax.defaults = {
		block_event : false,
		method : 'post',
		url : false,
		type : 'script',
		dataString : false,
		target : false,
		callback : function(){},

		// Spinner defaults
		use_spinner : true,
		spinner_message : 'Processing...',
		
		// Confirmation defaults
		confirm_action : false,
		confirm_message : 'Are you sure?',
		confirm_proceed_button : 'Yes, proceed!',
		confirm_cancel_button : 'Cancel',
		confirm_cancel_callback : function(){}
	};

})(jQuery);