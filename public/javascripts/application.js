// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(function(){

    $.livequery.registerPlugin('fadeIn');
    
    if(!$.metadata){$.require('jquery/jquery.metadata.js');}
    if(!$.log){$.require('jquery/jquery.log.js');}
    if(!$.fn.pulse){$.require('jquery/jquery.pulse.js');}
    if(!$.idleTimer){$.require('jquery/jquery.idle-timer.js');}
    if(!$.simpleConfirm){$.require('jquery/jquery.simpleConfirm.js');}
    if(!$.simpleInsert){$.require('jquery/jquery.simpleInsert.js');}

    // Add javascript request type
    $.ajaxSetup({
        'beforeSend' : function(xhr) {
            xhr.setRequestHeader('Accept', 'text/javascript');
        }
    });

    // Handle button push
    $('body')
        .live('mousedown',function(e){
                if($(e.target).hasClass('button') || $(e.target).hasClass('button_small')){
                    $(e.target).addClass('pushed');
                }
            })
        .live('mouseup',function(e){
                $(e.target).removeClass('pushed');
            })
        .live('mouseout',function(e){
                $(e.target).removeClass('pushed');
            })


    // Alternate table rows & list items etc
    $('tbody tr:even').livequery(function(){
        $(this).removeClass('odd').addClass('even')
    });
    $('tbody tr:odd').livequery(function(){
        $(this).removeClass('even').addClass('odd')
    });

    // Add close button to auxiliary panels
    $('.auxiliary').livequery(function(){
            $('<img/>')
                    .attr({
                            src : '/images/clear.gif',
                            title : 'close',
                            alt : 'close',
                            id : 'close_panel'
                    })
                    .addClass('closeButton')
                    .css('display','none')
                    .appendTo(this)
                    .delay(1000)
                    .pulse()
                    .click(function(){
                            $(this).fadeOut('fast',function(){
                                    $(this).parent().fadeOut('fast',function(){
                                            $(this).parent().css('display','none').empty();
                                    });
                            });
                            if($('.message').size()){
                                    $('#module_messages')
                                            .fadeOut('fast',function(){
                                                    $(this).empty();
                                            });
                            }
                    });
    });

// Set up tooltips
    $('.tip').livequery(function(){
        if($(this).size()){
            // Load required resources
            if(!$.fn.tooltip){$.require('jquery/jquery.tooltip.js');}
            $(this).tooltip();
        }
    });

    // Handle AJAX form posts
    $('.ajaxed').livequery(function(){
        $(this).submit(function(event){
            // Load required resources
            if(!$.simpleAjax){$.require('jquery/jquery.simpleAjax.js');}
            // Submit form
            $.simpleAjax({
                block_event : event,
                url : this.action,
                dataString : $(this).serialize()
            });
        });
    });


    // Insert asynchronous content
    $('.insert').live('click', function(event) {
        // Load required resources
        if (!$.simpleInsert) { $.require('jquery/jquery.simpleInsert.js'); }
        // alert('Clicked on the link!');
        // Insert content
        $.simpleInsert({
           block_event : event,
           target : '#record_manager',
           source : this.href,
           callback : function(){ $('html, body').animate({scrollTop:0}, 'normal'); }
        });
    });

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