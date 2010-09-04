/*!
 * http://paulirish.com/2009/jquery-idletimer-plugin/
 */


 // API available in <= v0.8
 /*******************************
 
 // idleTimer() takes an optional argument that defines the idle timeout
 // timeout is in milliseconds; defaults to 30000
 $.idleTimer(10000);


 $(document).bind("idle.idleTimer", function(){
    // function you want to fire when the user goes idle
 });


 $(document).bind("active.idleTimer", function(){
  // function you want to fire when the user becomes active again
 });

 // pass the string 'destroy' to stop the timer
 $.idleTimer('destroy');
 
 // you can query if the user is idle or not with data()
 $.data(document,'idleTimer');  // 'idle'  or 'active'

 // you can get time elapsed since user when idle/active
 $.idleTimer('getElapsedTime'); // time since state change in ms
 
 ********/
 
 
 
 // API available in >= v0.9
 /*************************
 
 // bind to specific elements, allows for multiple timer instances
 $(elem).idleTimer(timeout|'destroy'|'getElapsedTime');
 $.data(elem,'idleTimer');  // 'idle'  or 'active'
 
 // if you're using the old $.idleTimer api, you should not do $(document).idleTimer(...)
 
 // element bound timers will only watch for events inside of them.
 // you may just want page-level activity, in which case you may set up
 //   your timers on document, document.documentElement, and document.body
 
 
 ********/

(function($){

$.idleTimer = function(newTimeout, elem){
  
    // defaults that are to be stored as instance props on the elem
    
    var idle    = false,        //indicates if the user is idle
        enabled = true,        //indicates if the idle timer is enabled
        timeout = 30000,        //the amount of time (ms) before the user is considered idle
        events  = 'mousemove keydown DOMMouseScroll mousewheel mousedown'; // activity is one of these events
        
    
    elem = elem || document;
    
    
        
    /* (intentionally not documented)
     * Toggles the idle state and fires an appropriate event.
     * @return {void}
     */
    var toggleIdleState = function(myelem){
    
        // curse you, mozilla setTimeout lateness bug!
        if (typeof myelem == 'number') myelem = undefined;
    
        var obj = $.data(myelem || elem,'idleTimerObj');
        
        //toggle the state
        obj.idle = !obj.idle;
        
        // reset timeout counter
        obj.olddate = +new Date;
        
        //fire appropriate event
        
        // create a custom event, but first, store the new state on the element
        // and then append that string to a namespace
        var event = jQuery.Event( $.data(elem,'idleTimer', obj.idle ? "idle" : "active" )  + '.idleTimer'   );
        
        // we dont want this to bubble
        event.stopPropagation();
        $(elem).trigger(event);            
    },

    /**
     * Stops the idle timer. This removes appropriate event handlers
     * and cancels any pending timeouts.
     * @return {void}
     * @method stop
     * @static
     */         
    stop = function(elem){
    
        var obj = $.data(elem,'idleTimerObj');
        
        //set to disabled
        obj.enabled = false;
        
        //clear any pending timeouts
        clearTimeout(obj.tId);
        
        //detach the event handlers
        $(elem).unbind('.idleTimer');
    },
    
    
    /* (intentionally not documented)
     * Handles a user event indicating that the user isn't idle.
     * @param {Event} event A DOM2-normalized event object.
     * @return {void}
     */
    handleUserEvent = function(){
    
        var obj = $.data(this,'idleTimerObj');
        
        //clear any existing timeout
        clearTimeout(obj.tId);
        
        
        
        //if the idle timer is enabled
        if (obj.enabled){
        
          
            //if it's idle, that means the user is no longer idle
            if (obj.idle){
                toggleIdleState(this);           
            } 
        
            //set a new timeout
            obj.tId = setTimeout(toggleIdleState, obj.timeout);
            
        }    
     };
    
      
    /**
     * Starts the idle timer. This adds appropriate event handlers
     * and starts the first timeout.
     * @param {int} newTimeout (Optional) A new value for the timeout period in ms.
     * @return {void}
     * @method $.idleTimer
     * @static
     */ 
    
    
    var obj = $.data(elem,'idleTimerObj') || new function(){};
    
    obj.olddate = obj.olddate || +new Date;
    
    //assign a new timeout if necessary
    if (typeof newTimeout == "number"){
        timeout = newTimeout;
    } else if (newTimeout === 'destroy') {
        stop(elem);
        return this;  
    } else if (newTimeout === 'getElapsedTime'){
        return (+new Date) - obj.olddate;
    }
    
    //assign appropriate event handlers
    $(elem).bind($.trim((events+' ').split(' ').join('.idleTimer ')),handleUserEvent);
    
    
    obj.idle    = idle;
    obj.enabled = enabled;
    obj.timeout = timeout;
    
    
    //set a timeout to toggle state
    obj.tId = setTimeout(toggleIdleState, obj.timeout);
    
    // assume the user is active for the first x seconds.
    $.data(elem,'idleTimer',"active");
    
    // store our instance on the object
    $.data(elem,'idleTimerObj',obj);  
    

    
}; // end of $.idleTimer()


// v0.9 API for defining multiple timers.
$.fn.idleTimer = function(newTimeout){
  
  this[0] && $.idleTimer(newTimeout,this[0]);
  
  return this;
}
    

})(jQuery);