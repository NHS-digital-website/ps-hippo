//API that stores data to a cookie for LMS behaviour testing
function createResetButton(API) {
	$('body').append($('<style id="spoor-clear-button">.spoor-clear-button { position:fixed; right:0px; bottom:0px; } </style>'));
	var $button = $('<button class="spoor-clear-button">Reset</button>');
	$('body').append($button);
	$button.on("click", function() {
		if (API) API.LMSClear();
		alert("Status Reset");
		window.location.reload();
	});
}

function storageWarning() {
	var Adapt;
	var notificationMethod = alert;
	this.__storageWarningTimeoutId = null;
	if (require) Adapt = require('coreJS/adapt');
	if (Adapt && Adapt.config && Adapt.config.has('_elfh_spoor')) {
		if (Adapt.config.get('_elfh_spoor')._advancedSettings &&
			Adapt.config.get('_elfh_spoor')._advancedSettings._suppressErrors === true) {
			notificationMethod = console.error;
		}
	}
	notificationMethod('Warning: possible cookie storage limit exceeded - tracking may malfunction');
}

var API = {
	
	__offlineAPIWrapper:true,

	LMSInitialize: function() {
		//if (window.ISCOOKIELMS !== false) createResetButton(this);
		if (!API.LMSFetch()) {
			this.data["cmi.core.lesson_status"] = "not attempted";
			this.data["cmi.suspend_data"] = "";
			this.data["cmi.core.student_name"] = "Surname, Sam";
			this.data["cmi.core.student_id"] = "sam.surname@example.org";
			API.LMSStore(true);
		}
		return "true";
	},
	LMSFinish: function() {
		return "true";
	},
	LMSGetValue: function(key) {
		return this.data[key];
	},
	LMSSetValue: function(key, value) {
		var str = 'cmi.interactions.';
		if (key.indexOf(str) != -1) return "true";

		this.data[key] = value;
		
		API.LMSStore();
		return "true";
	},
	LMSCommit: function() {
		return "true";
	},
	LMSGetLastError: function() {
		return 0;
	},
	LMSGetErrorString: function() {
		return "Fake error string.";
	},
	LMSGetDiagnostic: function() {
		return "Fake diagnostic information.";
	},
	LMSStore: function(force) {
		if (window.ISCOOKIELMS === false) return;
		if (!force && API.cookie("_elfh_spoor") === undefined) return;

		var stringified = JSON.stringify(this.data);

		API.cookie("_elfh_spoor", stringified);

		// a length mismatch will most likely indicate cookie storage limit exceeded
		if (API.cookie("_elfh_spoor").length != stringified.length) {
			// defer call to avoid excessive alerts
			if (this.__storageWarningTimeoutId == null) {
				this.__storageWarningTimeoutId = setTimeout(function() {storageWarning.apply(API);}, 1000);
			}
		}
	},
	LMSFetch: function() {
		if (window.ISCOOKIELMS === false) {
			this.data = {};
			return;
		}
		this.data = API.cookie("_elfh_spoor");
		if (this.data === undefined) {
			this.data = {};
			return false;
		} else {
			this.data = JSON.parse(this.data);
			return true;
		}
	},
	LMSClear: function() {
		API.removeCookie("_elfh_spoor");
	}
};

var API_1484_11 = {

	__offlineAPIWrapper:true,

	Initialize: function() {
		//if (window.ISCOOKIELMS !== false) createResetButton(this);
		if (!API_1484_11.LMSFetch()) {
			this.data["cmi.completion_status"] = "not attempted";
			this.data["cmi.suspend_data"] = "";
			this.data["cmi.learner_name"] = "Surname, Sam";
			this.data["cmi.learner_id"] = "sam.surname@example.org";
			API_1484_11.LMSStore(true);
		}
		return "true";
	},
	Terminate: function() {
		return "true";
	},
	GetValue: function(key) {
		return this.data[key];
	},
	SetValue: function(key, value) {
		var str = 'cmi.interactions.';
		if (key.indexOf(str) != -1) return "true";

		this.data[key] = value;

		API_1484_11.LMSStore();
		return "true";
	},
	Commit: function() {
		return "true";
	},
	GetLastError: function() {
		return 0;
	},
	GetErrorString: function() {
		return "Fake error string.";
	},
	GetDiagnostic: function() {
		return "Fake diagnostic information.";
	},
	LMSStore: function(force) {
		if (window.ISCOOKIELMS === false) return;
		if (!force && API_1484_11.cookie("_elfh_spoor") === undefined) return;

		var stringified = JSON.stringify(this.data);

		API_1484_11.cookie("_elfh_spoor", stringified);

		// a length mismatch will most likely indicate cookie storage limit exceeded
		if (API_1484_11.cookie("_elfh_spoor").length != stringified.length) {
			// defer call to avoid excessive alerts
			if (this.__storageWarningTimeoutId == null) {
				this.__storageWarningTimeoutId = setTimeout(function() {storageWarning.apply(API_1484_11);}, 1000);
			}
		}
	},
	LMSFetch: function() {
		if (window.ISCOOKIELMS === false) {
			this.data = {};
			return;
		}
		this.data = API_1484_11.cookie("_elfh_spoor");
		if (this.data === undefined) {
			this.data = {};
			return false;
		} else {
			this.data = JSON.parse(this.data);
			return true;
		}
	},
	LMSClear: function() {
		API_1484_11.removeCookie("_elfh_spoor");
	}
};

//Extend both APIs with the jquery.cookie code https://github.com/carhartl/jquery-cookie
(function () {

	var $;

	for (var i = 0, count = arguments.length; i < count; i++) {

		$ = arguments[i];

		$.extend = function() {
			var src, copyIsArray, copy, name, options, clone,
				target = arguments[0] || {},
				i = 1,
				length = arguments.length;

			// Handle case when target is a string or something (possible in deep copy)
			if ( typeof target !== "object" && typeof target != "function" ) {
				target = {};
			}

			// extend jQuery itself if only one argument is passed
			if ( i === length ) {
				target = this;
				i--;
			}

			for ( ; i < length; i++ ) {
				// Only deal with non-null/undefined values
				if ( (options = arguments[ i ]) != null ) {
					// Extend the base object
					for ( name in options ) {
						src = target[ name ];
						copy = options[ name ];

						// Prevent never-ending loop
						if ( target === copy ) {
							continue;
						}

						if ( copy !== undefined ) {
							target[ name ] = copy;
						}
					}
				}
			}

			// Return the modified object
			return target;
		};

		var pluses = /\+/g;

		/**
		 * Safari-for-iOS 10 doesn't like values in JSON strings to contain commas, and will simply
		 * truncate the data at the point it finds one - see https://github.com/adaptlearning/adapt_framework/issues/1589
		 * We can't just URL-encode the entire thing as that pretty much doubles the size of the data, see:
		 * https://github.com/adaptlearning/adapt_framework/issues/1535
		 * According to https://developer.mozilla.org/en-US/docs/Web/API/document/cookie, semi-colons and whitespace
		 * are also disallowed, but so far we don't seem to be having problems because of them
		 */
		function urlEncodeDisallowedChars(value) {
			var s = (config.json ? JSON.stringify(value) : String(value));
			return s.replace(/,/g, '%2C');
		}

		function parseCookieValue(s) {
			if (s.indexOf('"') === 0) {
				// This is a quoted cookie as according to RFC2068, unescape...
				s = s.slice(1, -1).replace(/\\"/g, '"').replace(/\\\\/g, '\\');
			}

			try {
				// Replace server-side written pluses with spaces.
				// If we can't decode the cookie, ignore it, it's unusable.
				// If we can't parse the cookie, ignore it, it's unusable.
				s = decodeURIComponent(s.replace(pluses, ' '));
				return config.json ? JSON.parse(s) : s;
			} catch(e) {}
		}

		function read(s, converter) {
			var value = config.raw ? s : parseCookieValue(s);
			return typeof converter == "function" ? converter(value) : value;
		}

		var config = $.cookie = function (key, value, options) {

			// Write

			if (arguments.length > 1 && typeof value != "function") {
				options = $.extend({}, config.defaults, options);

				if (typeof options.expires === 'number') {
					var days = options.expires, t = options.expires = new Date();
					t.setTime(+t + days * 864e+5);
				}

				return (document.cookie = [
					key, '=', urlEncodeDisallowedChars(value),
					options.expires ? '; expires=' + options.expires.toUTCString() : '', // use expires attribute, max-age is not supported by IE
					options.path    ? '; path=' + options.path : '',
					options.domain  ? '; domain=' + options.domain : '',
					options.secure  ? '; secure' : ''
				].join(''));
			}

			// Read

			var result = key ? undefined : {};

			// To prevent the for loop in the first place assign an empty array
			// in case there are no cookies at all. Also prevents odd result when
			// calling $.cookie().
			var cookies = document.cookie ? document.cookie.split('; ') : [];

			for (var i = 0, l = cookies.length; i < l; i++) {
				var parts = cookies[i].split('=');
				var name = parts.shift();
				var cookie = parts.join('=');

				if (key && key === name) {
					// If second argument (value) is a function it's a converter...
					result = read(cookie, value);
					break;
				}

				// Prevent storing a cookie that we couldn't decode.
				if (!key && (cookie = read(cookie)) !== undefined) {
					result[name] = cookie;
				}
			}

			return result;
		};

		config.defaults = {};

		$.removeCookie = function (key, options) {
			if ($.cookie(key) === undefined) {
				return false;
			}

			// Must not alter options, thus extending a fresh object...
			$.cookie(key, '', $.extend({}, options, { expires: -1 }));
			return !$.cookie(key);
		};
	}

})(API, API_1484_11);
