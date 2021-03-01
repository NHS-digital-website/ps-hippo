<#ftl output_format="HTML">

<#-- Documentation: data-slugified-value is the slugified value of the tag link -->

<script>
    function HubTagFilter($el) {
        if (typeof $el === 'undefined') {
            return;
        }

        var DEFAULT_VALUE = 'DEFAULT_VALUE';
        var DEFAULT_KEY = 'DEFAULT_KEY';
        var TYPE = 'TAG';

        var _this = this;
        _this.$el = $el;

        _this.$links = _this.$el.querySelectorAll('a');
        _this.key = _this.$el.getAttribute('data-hub-filter-key') || DEFAULT_KEY;
        _this.name = generateName();
        setValue(DEFAULT_VALUE);

        function getType() {
            return TYPE;
        }

        function getKey() {
            return _this.key;
        }

        function resetValue(value) {
            value = typeof value !== 'undefined' ? value : '';
            setValue(value);

            if (_this.$el.querySelectorAll('.selected').length) {
                window.vjsu.removeClass(_this.$el.querySelectorAll('.selected')[0], 'selected');
            }

            var $matchingLink = _this.$el.querySelector('a[data-slugified-value="' + value + '"]');

            if ($matchingLink) {
               window.vjsu.addClass($matchingLink, 'selected');
            }
        }

        function setValue(value) {
            _this.value = value;
        }

        function getValue() {
            return _this.value;
        }

        function getDefaultValue() {
            if (getValue() === DEFAULT_VALUE) {
                return;
            }

            return getValue();
        }

        function getEl() {
            return _this.$el;
        }

        function getName() {
            return _this.name;
        }

        function generateName() {
            return 'HubTagFilter_' + Math.round(Math.random() * 1000000) + '-' + Math.round(Math.random() * 1000000);
        }

        function onChange(callback) {
            if (typeof callback === 'function') {
                _this.onChangeCallback = callback;
            }
        }

        (function init() {
            for (var i = 0; i < _this.$links.length; i++) {
                var $link = _this.$links[i];

                if (window.vjsu.hasClass($link, 'selected')) {
                    setValue($link.getAttribute('data-slugified-value'));
                }

                $link.addEventListener('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();

                    if (window.vjsu.hasClass(e.currentTarget, 'expand-tags-link')) {
                        for (var ii = 0; ii < _this.$links.length; ii++) {
                            if (window.vjsu.hasClass(_this.$links[ii], 'expand-tags-link')) {
                                window.vjsu.addClass(_this.$links[ii], 'expand-tags-link--hidden');
                            } else {
                                window.vjsu.removeClass(_this.$links[ii], 'tag-link--hidden');
                            }
                        }
                        return;
                    }

                    if (window.vjsu.hasClass(e.currentTarget, 'selected')) {
                        window.vjsu.removeClass(e.currentTarget, 'selected');
                        setValue("all");
                        e.currentTarget.blur();
                    } else {
                        if (_this.$el.querySelectorAll('.selected').length) {
                            window.vjsu.removeClass(_this.$el.querySelectorAll('.selected')[0], 'selected');
                        }
                        window.vjsu.addClass(e.currentTarget, 'selected');
                        setValue(e.currentTarget.getAttribute('data-slugified-value'));
                    }
                    if (typeof _this.onChangeCallback === 'function') {
                        _this.onChangeCallback.apply(this, [hubTagFilter]);
                    }
                });
            }
        })();

        var hubTagFilter =  {
            getKey:             getKey,
            getValue:           getValue,
            resetValue:         resetValue,
            getDefaultValue:    getDefaultValue,
            getName:            getName,
            getEl:              getEl,
            onChange:           onChange,
            getType:            getType
        };

        return hubTagFilter;
    };
</script>
