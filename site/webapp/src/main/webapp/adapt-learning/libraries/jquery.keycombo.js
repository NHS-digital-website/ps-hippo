(function($){
    var down = {};
    var handlers = {};

    // $.onKeyCombo([keyCode1, keyCode2, ...], function);

    $.onKeyCombo = function (keys, handler) {
        if (keys.length === 0 || typeof handler != 'function') {
            return;
        }

        // organise handlers according to how many keys each is listening for
        if (!handlers[keys.length]) handlers[keys.length] = [];
        handlers[keys.length].push({trigger:keys, handler:handler});
        
        $(document).keydown(function (event) {
            down[event.which] = true;
        }).keyup(function (event) {
            // as soon as a key is lifted examine the appropriate handlers

            // get pressed keys as array of integers
            var pressed = _.map(_.keys(down), function (num) { return parseInt(num, 10); });
            // the number of keys held
            var count = pressed.length;
            // the group of handlers listening for [count] keys
            var collection = handlers[count];
            // the handlers to call
            var execute = [];

            if (collection) {
                // look at handlers listening for [count] keys
                for (var j = 0; j < collection.length; j++) {
                    var trigger = collection[j].trigger;
                    var handler = collection[j].handler;
                    
                    // check for match
                    if (pressed.length == trigger.length && _.difference(pressed, trigger).length == 0) {
                        execute.push(handler);
                    }
                }
            }

            _.each(pressed, function(p) {
                delete down[p];
            });

            _.each(execute, function(handler) {
                console.log('$.onKeyCombo: firing handler for keys '+trigger.toString());
                handler(event);
            });
        });
    };

    $.offKeyCombo = function (keys, handler) {
        if (keys.length === 0 || typeof handler != 'function') {
            return;
        }

        var collection = handlers[keys.length];

        if (!collection) return;

        var index = _.findIndex(collection, function(i) {
            return i.trigger.length == keys.length && _.difference(i.trigger, keys).length == 0 && i.handler == handler;
        });

        if (index != -1) {
            collection.splice(index, 1);
        }
    };
})($);