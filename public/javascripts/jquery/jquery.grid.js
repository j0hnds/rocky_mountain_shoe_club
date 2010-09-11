/**
 * GRID PLUGIN
 */

(function($){

	// Load required resources
	if(!$.preLoadImages){$.require('jquery/jquery.preLoadImages.js');}

	$.fn.grid = function(options){

		// Set options
		var options = $.extend($.fn.grid.defaults, options);

		// Pre load spinner image
		$.preLoadImages(options.spinner);

		return this.each(function(){

			// Get original classes
			options.classes = $(this).attr('class');

			// Set grid structure
			var $grid = $(this).buildGrid(options);
			var table = function(){
				this.resizeGrid;
			};

			// Mask grid to show "progress"
			$grid.maskGrid();

			// Set width of grid & columns
			$grid.resizeGrid(options);

			// Rebuild table on window resize
			if(options.autoResize){

				$(window).bind('resize',function(){
					if(options.loader){
						$grid.maskGrid();
					}
					if(table.resizeGrid){
						clearTimeout(table.resizeGrid);
					}
					table.resizeGrid = setTimeout(function(){
						$grid.resizeGrid(options);
					}, 200);
				});
			}
		});
	};

	/**
	 * Set Up Grid Structure
	 */

	$.fn.buildGrid = function(options){

		var $innerWrapper = $('<div/>')
					.addClass('grid_inner_wrapper'),

				$dataWrapper = $('<div/>')
					.addClass('grid_data_wrapper')
					.css('overflow','auto'),

				// Float wrapper - prevents grid from screwing up page layout
				$floatWrapper = $('<div/>')
					.addClass('grid_float_wrapper')
					.css('overflow','auto'),

				// Outer wrapper - basis for width calculation etc
				$outerWrapper = $('<div/>')
					.addClass('grid_outer_wrapper')
					.css({
						"position" : "relative",
						"overflow" : "hidden",
						"display" : "block",
						"width" : "100%",
						"float" : "left"
					}),

				// Spinner for grid loader
				$spinner = $('<img/>')
					.addClass('grid_spinner')
					.css({
						position : 'absolute'
					})
					.attr('src',options.spinner),

				// Loader - mask for grid redraw
				$loader = $('<div/>')
					.addClass('grid_loader')
					.css({
						background : '#666',
						position : 'absolute',
						top : 0,
						left : 0,
						zIndex : 100,
						display : 'none',
						'-moz-border-radius' : '3px',
						'-webkit-border-radius' : '3px'
					})
					.append($spinner),

				// Set data cells
				$table = $(this)
					.addClass('grid_data_table')
					.find('tbody td,tbody th')
					.each(function(i){
						$(this)
							.buildCells('dc');
					})
					.end();

				// Set header cells
				if($table.find('thead').size()){
					$table.find('thead th,thead td')
						.each(function(i){
							$(this)
								.addClass('th'+i)
								.buildCells('hc');
						})
				}

				// Set header cells
				if($table.find('tfoot').size()){
					$table.find('tfoot th,tfoot td')
						.each(function(i){
							$(this)
								.addClass('th'+i)
								.buildCells('fc');
						})
				}

		// Set grid object
		var $grid = $table
			.wrap($floatWrapper)
			.wrap($outerWrapper)
			.wrap($innerWrapper)
			.wrap($dataWrapper)
			.closest('.grid_outer_wrapper');

		// Build header & footer
		$grid
			.find('.grid_inner_wrapper')
			.prepend(function(){
				if($table.find('thead').size()){
					return '<div class="grid_header_wrapper"><div class="grid_horizontal_scroll_wrapper"><table class="grid_header_table '+options.classes+'"></table></div></div>';
				} else {
					return;
				}
			})
			.append(function(){
				if($table.find('tfoot').size()){
					return '<div class="grid_footer_wrapper"><div class="grid_horizontal_scroll_wrapper"><table class="grid_footer_table '+options.classes+'"></table></div></div>';
				} else {
					return;
				}
			});

		// Capture header/footer tables
		var $headerTable = $grid.find('.grid_header_table'),
				$footerTable = $grid.find('.grid_footer_table');

		// Add header & footer
		$table
			.find('thead')
			.clone()
			.prependTo($headerTable);

		// Add footer
		$table
			.find('tfoot')
			.clone()
			.prependTo($footerTable);

		// Optional loader
		if(options.loader){
			$grid.prepend($loader);
		}

		return $grid;
	};

	/**
	 * Grid Resize Method
	 */

	$.fn.resizeGrid = function(options){

		// Set grid
		var $grid = $(this);

		// Require footer or header
		if(!$grid.find('thead') && !$grid.find('tfoot')){
			return;
		}

		// Get width
		var scrollWidth, outerWidth = $grid.width();

		// Get width minus scroll bar
		if($.browser.msie == true){
			scrollWidth = outerWidth - 17; // Internet Exploder
		} else if($.browser.safari == true){
			scrollWidth = outerWidth - 15; // Safari
		} else {
			scrollWidth = outerWidth - 16; // Everything else
		}

		var $dataTable = $grid.find('.grid_data_table');

		// Set wrapper & data table widths
		$grid
			.find('.grid_inner_wrapper,.grid_data_wrapper')
			.width(outerWidth);
		$dataTable
			.width(scrollWidth);

		// Show original header/footer
		$dataTable
			.find('thead tr,tfoot tr')
			.css('display','');

		// Reset cells
		$dataTable
			.find('div.hc,div.dc,div.fc')
			.width('auto');

		// Set horiztonal scroll width
		$grid
			.find('.horizontal_scroll_wrapper')
			.width(scrollWidth);

		// Set header/footer outer wrapper width
		$grid
			.find('.grid_header_wrapper,.grid_footer_wrapper')
			.width(outerWidth);

		// Set header/footer table width
		$grid
			.find('.grid_header_table,.grid_footer_table')
			.width(scrollWidth);

		// Get column widths, then hide original header/footer
		var width = [];
		$dataTable
			.find('thead th')
			.each(function(i){
				width[i] = $(this).width();
			})
			.end()
			.find('thead tr,tfoot tr')
			.css('display','none');

		// Set widths of new header/footer/data cells
		$dataTable
			.find('tbody tr:first td')
			.each(function(i){
				$(this)
					.find('div.dc')
					.width(width[i]);
				$grid
					.find('th.th'+i+' div.hc')
					.width(width[i]);
				$grid
					.find('th.th'+i+' div.fc')
					.width(width[i]);
			});

		// Set height of the data table
		$grid
			.find('.grid_data_wrapper')
			.height(options.height+'px')
			.scroll(function(){
				$grid
					.find('.grid_horizontal_scroll_wrapper')
					.css('margin-left',(-this.scrollLeft)+'px');
			});

		// Hide loader
		if(options.loader){
			if($grid.is(':visible')){ // console.log('unmask '+$grid.closest('.panel').attr('id'));
				$grid
					.find('.grid_loader')
					.fadeOut();
			}
		}
	};

	/**
	 * Cell Builder Method
	 */

	$.fn.buildCells = function(tag){
		return $(this)
			.wrapInner('<div class="'+tag+'"></div>');
	};

	/**
	 * Grid Mask Method
	 */

	$.fn.maskGrid = function(){
		var $grid = $(this),
				height = $grid.height(),
				width = $grid.width();
		if($grid.is(':visible')){ // console.log('mask '+$(this).closest('.panel').attr('id'));
			$grid
				.find('.grid_loader')
				.css({
					display : 'block',
					width : width,
					height : height
				})
				.end()
				.find('.grid_spinner')
				.css({
					left:(width/2 - 16),
					top:(height/2 - 16)
				});
		}
	};

	/**
	 * Set Defaults
	 */

	$.fn.grid.defaults = {
		loader : true,
		autoResize : true,
		height : '300',
		spinner : '/images/interface/page_spinner.gif',
		classes : ''
	};

})(jQuery);