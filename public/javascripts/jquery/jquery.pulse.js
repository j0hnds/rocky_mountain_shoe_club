/**
* PULSE PLUGIN
* -----------------------------------------------
* Causes an element to fade in/out rapidly to catch
* a users attention
*
* Example Use
*	-----------------------------------------------
* $('#myDiv').pulse({
*		count : 2
*	});
*/

(function($){

	$.fn.pulse = function(options){

		// Set globals
		var settings = $.extend({}, $.fn.pulse.defaults, options),
				validSpeeds = {fast:1, normal:1, slow:1};

		return this.each(function(){

			// Set locals
			var $this = $(this)
					n = settings.count;

			// Pulse method
			function pulse(){
				--n;
				$this.fadeOut(settings.speed,function(){
					$this.fadeIn(settings.speed,function(){
						n ? pulse() : settings.callback();
					});
				});
			}	

			// Show first if hidden
			if($this.is(':hidden')){
				$this.fadeIn(settings.speed,function(){
					--n;
					pulse();
				})
			} else {
				pulse();
			}

		});
	};

	// Set defaults
	$.fn.pulse.defaults = {
		count : 3,
		speed : 'fast',
		callback : function(){}
	};

})(jQuery);
