/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, { enumerable: true, get: getter });
/******/ 		}
/******/ 	};
/******/
/******/ 	// define __esModule on exports
/******/ 	__webpack_require__.r = function(exports) {
/******/ 		if(typeof Symbol !== 'undefined' && Symbol.toStringTag) {
/******/ 			Object.defineProperty(exports, Symbol.toStringTag, { value: 'Module' });
/******/ 		}
/******/ 		Object.defineProperty(exports, '__esModule', { value: true });
/******/ 	};
/******/
/******/ 	// create a fake namespace object
/******/ 	// mode & 1: value is a module id, require it
/******/ 	// mode & 2: merge all properties of value into the ns
/******/ 	// mode & 4: return value when already ns object
/******/ 	// mode & 8|1: behave like require
/******/ 	__webpack_require__.t = function(value, mode) {
/******/ 		if(mode & 1) value = __webpack_require__(value);
/******/ 		if(mode & 8) return value;
/******/ 		if((mode & 4) && typeof value === 'object' && value && value.__esModule) return value;
/******/ 		var ns = Object.create(null);
/******/ 		__webpack_require__.r(ns);
/******/ 		Object.defineProperty(ns, 'default', { enumerable: true, value: value });
/******/ 		if(mode & 2 && typeof value != 'string') for(var key in value) __webpack_require__.d(ns, key, function(key) { return value[key]; }.bind(null, key));
/******/ 		return ns;
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = 0);
/******/ })
/************************************************************************/
/******/ ({

/***/ "./src/nhsd/components/organisms/global-header/global-header.js":
/*!**********************************************************************!*\
  !*** ./src/nhsd/components/organisms/global-header/global-header.js ***!
  \**********************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
eval("__webpack_require__.r(__webpack_exports__);\n/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, \"default\", function() { return NHSDGlobalHeader; });\n/* global document window */\n// Singleton\nlet instance = null;\nclass NHSDGlobalHeader {\n  constructor() {\n    if (!instance) {\n      this.hostEl = document.querySelector('#nhsd-global-header');\n\n      if (this.hostEl) {\n        instance = this;\n        this.init();\n      }\n\n      return null;\n    }\n\n    return instance;\n  }\n\n  init() {\n    this.html = document.querySelector('html');\n    this.body = document.body;\n    this.logoEl = this.hostEl.querySelector('#nhsd-global-header__logo');\n    this.menuBarEl = this.hostEl.querySelector('#nhsd-global-header__menu');\n    this.searchInput = this.hostEl.querySelector('#query');\n    this.cachedProps = {\n      html: {\n        overflow: this.html.style.overflow,\n        height: this.html.style.height\n      },\n      body: {\n        overflow: this.html.style.overflow,\n        height: this.html.style.height\n      }\n    };\n    this.initMenuBar();\n    this.initSearchBar(); // Handle resize event\n\n    window.addEventListener('resize', () => {\n      // Close the menu on desktops\n      if (window.innerWidth >= 1240 && this.menuBarActive) {\n        this.closeMenuBar();\n      }\n    });\n  }\n\n  initMenuBar() {\n    this.menuButtonEl = this.hostEl.querySelector('#nhsd-global-header__menu-button');\n    this.menuButtonEl.addEventListener('click', event => {\n      event.preventDefault();\n      event.stopPropagation();\n\n      if (!this.menuBarActive) {\n        this.openMenuBar();\n      } else {\n        this.closeMenuBar();\n      }\n\n      if (this.searchBarActive) {\n        this.closeSearchBar();\n      }\n\n      this.setDocumentScrolling();\n    });\n    this.menuCloseButtonEl = this.hostEl.querySelector('#nhsd-global-header__menu-close-button');\n    this.menuCloseButtonEl.addEventListener('click', event => {\n      event.preventDefault();\n      event.stopPropagation();\n      this.closeMenuBar();\n      this.setDocumentScrolling();\n    });\n  }\n\n  initSearchBar() {\n    this.searchButtonEl = this.hostEl.querySelector('#nhsd-global-header__search-button');\n    this.searchButtonEl.addEventListener('click', event => {\n      event.preventDefault();\n      event.stopPropagation();\n\n      if (!this.searchBarActive) {\n        this.openSearchBar();\n      } else {\n        this.closeSearchBar();\n      }\n\n      if (this.menuBarActive) {\n        this.closeMenuBar();\n      }\n\n      this.setDocumentScrolling();\n    });\n    this.searchCloseButtonEl = this.hostEl.querySelector('#nhsd-global-header__search-close-button');\n    this.searchCloseButtonEl.addEventListener('click', event => {\n      event.preventDefault();\n      event.stopPropagation();\n      this.closeSearchBar();\n      this.setDocumentScrolling();\n    });\n  }\n\n  openMenuBar() {\n    this.hostEl.classList.add('js-menu-active');\n    this.menuButtonEl.classList.add('js-active');\n    this.menuBarActive = true;\n    this.menuButtonEl.setAttribute('aria-expanded', true);\n    this.setTabIndexes();\n  }\n\n  closeMenuBar() {\n    this.hostEl.classList.remove('js-menu-active');\n    this.menuButtonEl.classList.remove('js-active');\n    this.menuBarActive = false;\n    this.menuButtonEl.setAttribute('aria-expanded', false);\n    this.setTabIndexes();\n  }\n\n  openSearchBar() {\n    this.hostEl.classList.add('js-search-active');\n    this.searchButtonEl.classList.add('js-active');\n    this.searchButtonEl.blur();\n    this.searchInput.focus();\n    this.searchButtonEl.setAttribute('aria-expanded', true);\n    this.searchBarActive = true;\n  }\n\n  closeSearchBar() {\n    this.hostEl.classList.remove('js-search-active');\n    this.searchButtonEl.classList.remove('js-active');\n    this.searchButtonEl.blur();\n    this.searchButtonEl.setAttribute('aria-expanded', false);\n    this.searchBarActive = false;\n  }\n\n  setDocumentScrolling() {\n    if (this.hostEl.classList.contains('js-menu-active') || this.hostEl.classList.contains('js-search-active')) {\n      this.html.style.overflow = 'hidden';\n      this.body.style.overflow = 'hidden';\n      this.html.style.height = '100%';\n      this.body.style.height = '100%';\n    } else {\n      this.html.style.overflow = this.cachedProps.html.overflow ? this.cachedProps.html.overflow : null;\n      this.html.style.height = this.cachedProps.html.height ? this.cachedProps.html.height : null;\n      this.body.style.overflow = this.cachedProps.body.overflow ? this.cachedProps.body.overflow : null;\n      this.body.style.height = this.cachedProps.body.height ? this.cachedProps.body.height : null;\n    }\n  }\n\n  setTabIndexes() {\n    const menuItems = Array.from(this.menuBarEl.querySelectorAll('.nhsd-a-menu-item'));\n\n    if (this.menuBarActive) {\n      let tabIndex = 0;\n      this.logoEl.setAttribute('tabindex', tabIndex += 1);\n      this.searchButtonEl.setAttribute('tabindex', tabIndex += 1);\n      this.menuButtonEl.setAttribute('tabindex', tabIndex += 1);\n      this.menuCloseButtonEl.setAttribute('tabindex', tabIndex += 1);\n      menuItems.forEach((el, index) => {\n        el.setAttribute('tabindex', tabIndex += index + 1);\n      });\n    } else {\n      this.logoEl.removeAttribute('tabindex');\n      this.searchButtonEl.removeAttribute('tabindex');\n      this.menuButtonEl.removeAttribute('tabindex');\n      this.menuCloseButtonEl.removeAttribute('tabindex');\n      menuItems.forEach(el => {\n        el.removeAttribute('tabindex');\n      });\n    }\n  }\n\n}\n\n//# sourceURL=webpack:///./src/nhsd/components/organisms/global-header/global-header.js?");

/***/ }),

/***/ "./src/nhsd/nhsd-frontend.js":
/*!***********************************!*\
  !*** ./src/nhsd/nhsd-frontend.js ***!
  \***********************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
eval("__webpack_require__.r(__webpack_exports__);\n/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, \"default\", function() { return NHSD; });\n/* harmony import */ var _components_organisms_global_header_global_header__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./components/organisms/global-header/global-header */ \"./src/nhsd/components/organisms/global-header/global-header.js\");\nfunction _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }\n\n/* global document window */\n // Singleton\n\nlet instance = null;\nclass NHSD {\n  constructor() {\n    _defineProperty(this, \"globalHeader\", null);\n\n    if (!instance) {\n      instance = this;\n      this.init();\n    }\n\n    return instance;\n  }\n\n  init() {\n    window.addEventListener('load', () => {\n      document.querySelector('html').classList.remove('nhsd-no-js');\n      this.globalHeader = new _components_organisms_global_header_global_header__WEBPACK_IMPORTED_MODULE_0__[\"default\"]();\n    });\n  }\n\n}\n/* eslint-disable no-unused-vars */\n// Self instantiating master class\n\nconst nhsd = new NHSD();\n/* eslint-enable no-unused-vars */\n\n//# sourceURL=webpack:///./src/nhsd/nhsd-frontend.js?");

/***/ }),

/***/ 0:
/*!********************************************************************************************************!*\
  !*** multi ./src/nhsd/nhsd-frontend.js ./src/nhsd/components/organisms/global-header/global-header.js ***!
  \********************************************************************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

eval("__webpack_require__(/*! /Users/josephcyrus/Documents/Projects/nhsd-frontend/src/nhsd/nhsd-frontend.js */\"./src/nhsd/nhsd-frontend.js\");\nmodule.exports = __webpack_require__(/*! /Users/josephcyrus/Documents/Projects/nhsd-frontend/src/nhsd/components/organisms/global-header/global-header.js */\"./src/nhsd/components/organisms/global-header/global-header.js\");\n\n\n//# sourceURL=webpack:///multi_./src/nhsd/nhsd-frontend.js_./src/nhsd/components/organisms/global-header/global-header.js?");

/***/ })

/******/ });
