/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/* OnReady() */
$(function() {
   $('.modal').live('submit', function(event) {
      // Load required resources
      if (!$.simpleAjax) { $.require('jquery/jquery.simpleAjax.js'); }

      // Submit form
      $.simpleAjax({
          block_event : event,
          url : this.action,
          type : 'script',
          dataString : $(this).serialize(),
          confirm_action : true,
          confirm_message : this.title,
          confirm_proceed_button : 'Yes, proceed'
      });
   });
    $.require('/jquery/jquery.grid.js');


    /* Setup scrolling tables */
    $('.grid').grid({ height : 250 });

    $.require('/jquery/jquery.tabs.js');

    $('.tabbed_panels').livequery(function() {
       // alert("Found the tabs stuff: " + this);
       $(this).tabs({
           panels : '.sample'
       });

        // Hook up the hyperlink to an add line edit field
        $('a#add_line').click(function() {
            // Get the value out of the input field (my sibling)
            line_value = $(this).parent().children('input').val();
            $('#line_fields').append('<li><input type="text" value="' + line_value + '" name="exhibitor[line][]"/><a href="#" class="small button line_up">Up</a><a href="#" class="small button line_down">Down</a><a href="#" class="small button line_remove">Remove</a></li>');
            // Now, clear out the field
            $(this).parent().children('input').val('');
        });

        $('.line_up').livequery('click', function() {
           if ($(this).parent().prev().length > 0) {
               my_value = $(this).parent().children('input').val();
               prev_value = $(this).parent().prev().children('input').val();
               $(this).parent().children('input').val(prev_value);
               $(this).parent().prev().children('input').val(my_value);
           }
        });
        $('.line_down').livequery('click', function() {
           if ($(this).parent().next().length > 0) {
               my_value = $(this).parent().children('input').val();
               next_value = $(this).parent().next().children('input').val();
               $(this).parent().children('input').val(next_value);
               $(this).parent().next().children('input').val(my_value);
           }
        });
        $('.line_remove').livequery('click', function() {
           $(this).parent().remove();
        });

    });

});