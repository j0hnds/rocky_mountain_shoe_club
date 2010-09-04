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
});