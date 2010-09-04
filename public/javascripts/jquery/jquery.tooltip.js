/**
* TOOLTIP PLUGIN
* -----------------------------------------------
* Adds tooltip to any element on the page where
* selector matches. Uses "title" tag for content or
* alternatively loads content via ajax
*
* Example Use
*	-----------------------------------------------
*	<p title="This is a tooltip!" class="tip">Mouseover this to get a tooltip</p>
*
*	$('.tip').tooltip();
*/

(function($){

	$.fn.tooltip = function(options) {

		this.each(function() {

			// Set locals
			var $this = $(this),
					settings = $.extend({}, $.fn.tooltip.defaults, options),
					o = $.metadata ? $.extend(settings, $this.metadata()) : settings,
					$tip = settings.tip ? settings.tip : this.title;

			// Remove title
			if($this.attr('title').length){$this.removeAttr('title');}

			// Mouseenter
			$this.hover(function(e) {

				// Kill any remaining tooltip
				$('#tooltip').remove();

				// Build new tooltip
				$('<div/>')
					.attr('id','tooltip')
					.appendTo('body')
					.html(
						function(){
							if(settings.url){
								$('#tooltip').load(settings.url);
								return false;
							} else {
								return $tip;
							}
						}()
					)
					.hide()
					.css({
						top: setTop(e),
						left: setLeft(e),
						width: function(){
							if(settings.width == 'auto'){
								return settings.width;
							} else if(settings.width != $.fn.tooltip.defaults.width){
								return settings.width + 'px';
							} else {
								return ($('#tooltip').width() > settings.width ? settings.width + 'px' : 'auto');
							}
						}()
					})
					.fadeIn(350);

			},

			// Mouseleave
			function() {

				// Kill tooltip
				$('#tooltip')
					.fadeOut(150,function(){
						$(this).remove();
					});
			});

			// Handle mouse movement when tip displayed
			$this
				.mousemove(function(e) {
					$('#tooltip').css({
						top: setTop(e),
						left: setLeft(e)
					});
				})
				.click(function(){
					$('#tooltip').remove();
				});

		});

		// Set location on Y axis
		function setTop(e){
			if(e.pageY < ($(window).height() / 2)){
				return e.pageY + 10;
			} else {
				return e.pageY - parseInt($('#tooltip').height()) - 20;
			}
		}

		// Set location on X axis
		function setLeft(e){
			if(e.pageX < ($(window).width() / 2)){
				return e.pageX + 10;
			} else {
				return e.pageX - (parseInt($('#tooltip').width()) + 20);
			}
		}

		return this;
	};

	// Set defaults
  $.fn.tooltip.defaults = {
		width : 120,
		tip : false,
		url : false
  };

})(jQuery);