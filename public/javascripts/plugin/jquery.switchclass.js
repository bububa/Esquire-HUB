/**
 *
 * jquery.SwitchClass.js - A jQuery Plugin
 * 
 * @version: 0.1
 * @author pedrocorreia.net
 * @date 2010-04-21
 * @projectDescription: Switch/ Replace/ Change an object's class name
 * @requires jquery.js (tested with 1.3.2)
 */
(function($){
 
    /**
     * Switch element(s) Class Name
     *
     * @author pedrocorreia.net
     *
     * @param Object || Array Selector(s) -> Syntax: [ {elem, old_class, new class}, ... ]
     */
    $.SwitchClass = function (selectors){
        var _selectors = [], //our selectors array container, it will hold all our objects
 
            /**
             * Switch Class
             *
             * @private
             * @param Jquery Object
             * @param String Old Class Name
             * @param String New Class Name
             */
            _Switch = function(o, oldClass, newClass){
                if(o && oldClass && newClass && o.hasClass(oldClass)){
                  o.removeClass(oldClass).addClass(newClass);
                }
            };
 
        //check if we have an object or an array of objects,
        //the "selectors" will always be in an array, even if we
        //specify an Object, this will be added to our selectors Array
        if($.isArray(selectors)){ _selectors = selectors; }
        else{ _selectors.push(selectors); }
 
        //do we have any elements in our, selectors, array?
        if (_selectors.length === 0) { return; }
 
        //iterate over selectors Array
        $.each(_selectors, function(idx, selector){
            _Switch($(selector.elem), selector.old_class, selector.new_class);
        });
    };
 
    /**
     * Switch element(s) Class Name
     * jQuery custom function
     * 
     * @author pedrocorreia.net
     *
     * @param String Old Class Name
     * @param String New Class Name
     * @extends jQuery
     */
    $.fn.SwitchClass = function(old_class, new_class){
      return this.each(function(){
        $.SwitchClass({elem: this, old_class: old_class, new_class: new_class});
      });
    };
 
})(jQuery);