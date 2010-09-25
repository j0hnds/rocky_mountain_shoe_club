/**
 * TABS PLUGIN
 * -----------------------------------------------
 * Creates dynamic tabs from standard markup. 
 *
 * Example Use
 *	-----------------------------------------------
 *	<div class="tabbed_panels">
 *
 *		<div class="tabs">
 *			<ul>
 *				<li><a href="#first_panel_name">[tab/panel name]</a></li>
 *				<li><a href="#second_panel_name">[tab/panel name]</a></li>
 *			</ul>
 *		</div>
 *
 *		<div class="panel" id="first_panel_name">
 *			<p>Panel content</p>
 *		</div>
 *
 *		<div class="panel" id="second_panel_name">
 *			<p>Panel content</p>
 *		</div>
 *
 *	</div>
 *
 *	$('.tabbed_panels').tabs();
 */

(function($){

	$.fn.tabs = function(options){

		return this.each(function(){

			// Set locals
			var $this = $(this),
					settings = $.extend({}, $.fn.tabs.defaults, options),
					o = $.metadata ? $.extend(settings, $this.metadata()) : settings;

			// Set onclick() behavior to tabs
			$(settings.tabs,$this)
				.click(function(event){

					// Kill default browser click
					event.preventDefault();

					// Set onclick() locals
					var currentTab = $(settings.tabs,$this).index(this),
							href = $(this).attr('href');

					// Hide all but selected panel
					$(settings.panels,$this)
						.hide()
						.filter(function(){
							// if(href.startsWith('#')){

								// Return corresponding panel
								return href;

							//} else {

								// Load remote panel content
							//	$('#' + href.split('#')[1]).load(href.split('#')[0]);

								// Return corresponding panel
							//	return '#' + href.split('#')[1];

							//}
						}())
						.show();

					// Select current tab
					$(settings.tabs,$this)
						.removeClass('selected')
						.filter(function(i){
							return i == currentTab;
						})
						.addClass('selected');

				})
				.filter(settings.current) // Select current tab element
				.trigger('click')//click(); // Click tab element

		});
	};

	// Tabbed navigation defaults
	$.fn.tabs.defaults = {
		tabs : '.tabs li a',
		panels : '.panel',
		current : ':first'
	};

})(jQuery);