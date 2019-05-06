import _regeneratorRuntime from "@babel/runtime/regenerator";

function _extends() { _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; }; return _extends.apply(this, arguments); }

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

function _possibleConstructorReturn(self, call) { if (call && (typeof call === "object" || typeof call === "function")) { return call; } return _assertThisInitialized(self); }

function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }

function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); if (superClass) _setPrototypeOf(subClass, superClass); }

function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf || function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }

/** @jsx h */
import 'codemirror/lib/codemirror.css';
import './styles.sass';
import './themes/one-light.sass';
import './themes/one-dark.sass';
import 'codemirror/mode/javascript/javascript';
import 'codemirror/addon/edit/matchbrackets';
import 'codemirror/addon/edit/closebrackets';
import 'codemirror/addon/edit/matchtags';
import 'codemirror/addon/edit/trailingspace';
import 'codemirror/addon/edit/closetag';
import 'codemirror/addon/display/placeholder';
import * as CodeMirror from 'codemirror';
import { Component, h, render } from 'preact';
import { MODES, loadMode } from '@chuspace/code-editor-modes';
import ClipboardJS from 'clipboard';
import { EditorView } from 'prosemirror-view';
var SVG_RATIO = 0.81;

var Copy = function Copy(props) {
  var width = SVG_RATIO * 16;
  return h("svg", {
    "class": "codemirror-copy",
    width: width,
    height: 16,
    viewBox: "0 0 13 16",
    fill: "none",
    xmlns: "http://www.w3.org/2000/svg"
  }, h("path", {
    d: "M8 0H3.40385C2.55385 0 1.84615 0.669231 1.84615 1.51923V1.84615H1.55769C0.707692 1.84615 0 2.51538 0 3.36538V14.4423C0 15.2923 0.707692 16 1.55769 16H9.55769C10.4077 16 11.0769 15.2923 11.0769 14.4423V14.1538H11.4038C12.2538 14.1538 12.9231 13.4462 12.9231 12.5962V4.92308L8 0ZM8 1.71538L11.2077 4.92308H8V1.71538ZM9.84615 14.4423C9.84615 14.6231 9.71538 14.7692 9.55769 14.7692H1.55769C1.38846 14.7692 1.23077 14.6115 1.23077 14.4423V3.36538C1.23077 3.20769 1.37692 3.07692 1.55769 3.07692H1.84615V12.9038C1.84615 13.7538 2.24615 14.1538 3.09615 14.1538H9.84615V14.4423ZM11.6923 12.5962C11.6923 12.7769 11.5615 12.9231 11.4038 12.9231H3.40385C3.23462 12.9231 3.07692 12.7654 3.07692 12.5962V1.51923C3.07692 1.36154 3.22308 1.23077 3.40385 1.23077H6.76923V6.15385H11.6923V12.5962Z",
    fill: 'black'
  }));
};

var Controls = function Controls(props) {
  return h("svg", {
    "class": "codemirror-controls",
    xmlns: "http://www.w3.org/2000/svg",
    width: "54",
    height: "14",
    viewBox: "0 0 54 14"
  }, h("g", {
    fill: "none",
    fillRule: "evenodd",
    transform: "translate(1 1)"
  }, h("circle", {
    cx: "6",
    cy: "6",
    r: "6",
    fill: "#FF5F56",
    stroke: "#E0443E",
    strokeWidth: ".5",
    onClick: props.destroy
  }), h("circle", {
    cx: "26",
    cy: "6",
    r: "6",
    fill: "#FFBD2E",
    stroke: "#DEA123",
    strokeWidth: ".5"
  }), h("circle", {
    cx: "46",
    cy: "6",
    r: "6",
    fill: "#27C93F",
    stroke: "#1AAB29",
    strokeWidth: ".5"
  })));
};

var LanguageSwitcher =
/*#__PURE__*/
function (_Component) {
  _inherits(LanguageSwitcher, _Component);

  function LanguageSwitcher(props) {
    var _this;

    _classCallCheck(this, LanguageSwitcher);

    _this = _possibleConstructorReturn(this, _getPrototypeOf(LanguageSwitcher).call(this, props));
    _this.props = void 0;

    _this.toggleSwitcher = function (e) {
      _this.setState({
        showSwitcher: !_this.state.showSwitcher
      });
    };

    _this.handleLanguageChange = function (e) {
      e.preventDefault();
      var mode = e.target.dataset.mode;

      _this.setState({
        mode: mode,
        showSwitcher: false
      });

      _this.props.setMode(mode);
    };

    _this.state = {
      mode: props.mode,
      showSwitcher: false
    };
    return _this;
  }

  _createClass(LanguageSwitcher, [{
    key: "render",
    value: function render() {
      var _this2 = this;

      return h("div", {
        "class": "codemirror-language-switcher-container"
      }, h("input", {
        type: "text",
        value: this.state.mode,
        "class": "codemirror-language-input",
        onFocus: this.toggleSwitcher
      }), this.state.showSwitcher && h("ul", {
        "class": "codemirror-language-switcher"
      }, MODES.map(function (_ref) {
        var name = _ref.name,
            mode = _ref.mode;
        return h("li", {
          onClick: _this2.handleLanguageChange,
          "data-mode": mode
        }, name);
      })));
    }
  }]);

  return LanguageSwitcher;
}(Component);

var Toolbar =
/*#__PURE__*/
function (_Component2) {
  _inherits(Toolbar, _Component2);

  function Toolbar(props) {
    var _this3;

    _classCallCheck(this, Toolbar);

    _this3 = _possibleConstructorReturn(this, _getPrototypeOf(Toolbar).call(this, props));
    _this3.view = void 0;
    _this3.clipboard = void 0;
    _this3.switcher = void 0;
    _this3.controls = void 0;
    _this3.copy = void 0;

    _this3.initClipboardJS = function (node) {
      return new ClipboardJS(node);
    };

    return _this3;
  }

  _createClass(Toolbar, [{
    key: "render",
    value: function render() {
      return h("div", {
        "class": "codemirror-toolbar"
      }, h(Controls, {
        destroy: this.props.destroy
      }), h("div", {
        "class": "codemirror-toolbar-menu"
      }, h(LanguageSwitcher, this.props), ' ', h("div", {
        ref: this.initClipboardJS,
        "data-clipboard-target": ".CodeMirror-code"
      }, h(Copy, null))));
    }
  }]);

  return Toolbar;
}(Component);

var Container =
/*#__PURE__*/
function (_Component3) {
  _inherits(Container, _Component3);

  function Container() {
    var _getPrototypeOf2;

    var _this4;

    _classCallCheck(this, Container);

    for (var _len = arguments.length, args = new Array(_len), _key = 0; _key < _len; _key++) {
      args[_key] = arguments[_key];
    }

    _this4 = _possibleConstructorReturn(this, (_getPrototypeOf2 = _getPrototypeOf(Container)).call.apply(_getPrototypeOf2, [this].concat(args)));
    _this4.cm = void 0;

    _this4.setMode =
    /*#__PURE__*/
    function () {
      var _ref2 = _asyncToGenerator(
      /*#__PURE__*/
      _regeneratorRuntime.mark(function _callee(mode) {
        return _regeneratorRuntime.wrap(function _callee$(_context) {
          while (1) {
            switch (_context.prev = _context.next) {
              case 0:
                _context.next = 2;
                return loadMode(mode);

              case 2:
                _this4.cm && _this4.cm.setOption('mode', mode);
                _this4.props.handleLanguageChange && _this4.props.handleLanguageChange(mode);

              case 4:
              case "end":
                return _context.stop();
            }
          }
        }, _callee);
      }));

      return function (_x) {
        return _ref2.apply(this, arguments);
      };
    }();

    _this4.createCM = function (node) {
      _this4.cm = new CodeMirror(node, {
        value: _this4.props.content,
        lineNumbers: true,
        smartIndent: !_this4.props.readOnly,
        readOnly: _this4.props.readOnly || false,
        mode: _this4.props.mode,
        indentWithTabs: !_this4.props.readOnly,
        theme: 'one-light',
        autofocus: !_this4.props.readOnly,
        addModeClass: true,
        lineWrapping: true,
        autoCloseBrackets: true,
        autoCloseTags: true,
        showTrailingSpace: true,
        matchTags: true,
        placeholder: "Start writing ".concat(_this4.props.mode, " code..."),
        extraKeys: _this4.props.codeMirrorKeymap && _this4.props.codeMirrorKeymap()
      });

      _this4.props.getCMInstance(_this4.cm);

      _this4.setMode(_this4.props.mode);
    };

    _this4.render = function () {
      return h("div", {
        "class": "codemirror-container",
        contentEditable: false
      }, h(Toolbar, _extends({}, _this4.props, {
        setMode: _this4.setMode
      })), h("span", {
        ref: _this4.createCM
      }));
    };

    return _this4;
  }

  return Container;
}(Component);

export { Container as default };
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uLy4uL2xpYi9jb21wb25lbnRzL2NvZGUtYmxvY2svaW5kZXguanMiXSwibmFtZXMiOlsiQ29kZU1pcnJvciIsIkNvbXBvbmVudCIsImgiLCJyZW5kZXIiLCJNT0RFUyIsImxvYWRNb2RlIiwiQ2xpcGJvYXJkSlMiLCJFZGl0b3JWaWV3IiwiU1ZHX1JBVElPIiwiQ29weSIsInByb3BzIiwid2lkdGgiLCJDb250cm9scyIsImRlc3Ryb3kiLCJMYW5ndWFnZVN3aXRjaGVyIiwidG9nZ2xlU3dpdGNoZXIiLCJlIiwic2V0U3RhdGUiLCJzaG93U3dpdGNoZXIiLCJzdGF0ZSIsImhhbmRsZUxhbmd1YWdlQ2hhbmdlIiwicHJldmVudERlZmF1bHQiLCJtb2RlIiwidGFyZ2V0IiwiZGF0YXNldCIsInNldE1vZGUiLCJtYXAiLCJuYW1lIiwiVG9vbGJhciIsInZpZXciLCJjbGlwYm9hcmQiLCJzd2l0Y2hlciIsImNvbnRyb2xzIiwiY29weSIsImluaXRDbGlwYm9hcmRKUyIsIm5vZGUiLCJDb250YWluZXIiLCJjbSIsInNldE9wdGlvbiIsImNyZWF0ZUNNIiwidmFsdWUiLCJjb250ZW50IiwibGluZU51bWJlcnMiLCJzbWFydEluZGVudCIsInJlYWRPbmx5IiwiaW5kZW50V2l0aFRhYnMiLCJ0aGVtZSIsImF1dG9mb2N1cyIsImFkZE1vZGVDbGFzcyIsImxpbmVXcmFwcGluZyIsImF1dG9DbG9zZUJyYWNrZXRzIiwiYXV0b0Nsb3NlVGFncyIsInNob3dUcmFpbGluZ1NwYWNlIiwibWF0Y2hUYWdzIiwicGxhY2Vob2xkZXIiLCJleHRyYUtleXMiLCJjb2RlTWlycm9yS2V5bWFwIiwiZ2V0Q01JbnN0YW5jZSJdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7O0FBRUE7QUFFQSxPQUFPLCtCQUFQO0FBQ0EsT0FBTyxlQUFQO0FBQ0EsT0FBTyx5QkFBUDtBQUNBLE9BQU8sd0JBQVA7QUFDQSxPQUFPLHVDQUFQO0FBQ0EsT0FBTyxxQ0FBUDtBQUNB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SzdCdEIsUUFBQUEsSUFBSSxFQUFFLE9BQUtaLEtBQUwsQ0FBV1ksSUFMWTtBQU03QnVCLFFBQUFBLGNBQWMsRUFBRSxDQUFDLE9BQUtuQyxLQUFMLENBQVdrQyxRQU5DO0FBTzdCRSxRQUFBQSxLQUFLLEVBQUUsV0FQc0I7QUFRN0JDLFFBQUFBLFNBQVMsRUFBRSxDQUFDLE9BQUtyQyxLQUFMLENBQVdrQyxRQVJNO0FBUzdCSSxRQUFBQSxZQUFZLEVBQUUsSUFUZTtBQVU3QkMsUUFBQUEsWUFBWSxFQUFFLElBVmU7QUFXN0JDLFFBQUFBLGlCQUFpQixFQUFFLElBWFU7QUFZN0JDLFFBQUFBLGFBQWEsRUFBRSxJQVpjO0FBYTdCQyxRQUFBQSxpQkFBaUIsRUFBRSxJQWJVO0FBYzdCQyxRQUFBQSxTQUFTLEVBQUUsSUFka0I7QUFlN0JDLFFBQUFBLFdBQVcsMEJBQW1CLE9BQUs1QyxLQUFMLENBQVdZLElBQTlCLGFBZmtCO0FBZ0I3QmlDLFFBQUFBLFNBQVMsRUFBRSxPQUFLN0MsS0FBTCxDQUFXOEMsZ0JBQVgsSUFBK0IsT0FBSzlDLEtBQUwsQ0FBVzhDLGdCQUFYO0FBaEJiLE9BQXJCLENBQVY7O0FBbUJBLGFBQUs5QyxLQUFMLENBQVcrQyxhQUFYLENBQXlCLE9BQUtwQixFQUE5Qjs7QUFDQSxhQUFLWixPQUFMLENBQWEsT0FBS2YsS0FBTCxDQUFXWSxJQUF4QjtBQUNELEs7O1dBRURuQixNLEdBQVMsWUFBTTtBQUNiLGFBQ0U7QUFBSyxpQkFBTSxzQkFBWDtBQUFrQyxRQUFBLGVBQWUsRUFBRTtBQUFuRCxTQUNFLEVBQUMsT0FBRCxlQUFhLE9BQUtPLEtBQWxCO0FBQXlCLFFBQUEsT0FBTyxFQUFFLE9BQUtlO0FBQXZDLFNBREYsRUFFRTtBQUFNLFFBQUEsR0FBRyxFQUFFLE9BQUtjO0FBQWhCLFFBRkYsQ0FERjtBQU1ELEs7Ozs7OztFQXhDb0N0QyxTOztTQUFsQm1DLFMiLCJzb3VyY2VzQ29udGVudCI6WyIvLyBAZmxvd1xuXG4vKiogQGpzeCBoICovXG5cbmltcG9ydCAnY29kZW1pcnJvci9saWIvY29kZW1pcnJvci5jc3MnXG5pbXBvcnQgJy4vc3R5bGVzLnNhc3MnXG5pbXBvcnQgJy4vdGhlbWVzL29uZS1saWdodC5zYXNzJ1xuaW1wb3J0ICcuL3RoZW1lcy9vbmUtZGFyay5zYXNzJ1xuaW1wb3J0ICdjb2RlbWlycm9yL21vZGUvamF2YXNjcmlwdC9qYXZhc2NyaXB0J1xuaW1wb3J0ICdjb2RlbWlycm9yL2FkZG9uL2VkaXQvbWF0Y2hicmFja2V0cydcbmltcG9ydCAnY29kZW1pcnJvci9hZGRvbi9lZGl0L2Nsb3NlYnJhY2tldHMnXG5pbXBvcnQgJ2NvZGVtaXJyb3IvYWRkb24vZWRpdC9tYXRjaHRhZ3MnXG5pbXBvcnQgJ2NvZGVtaXJyb3IvYWRkb24vZWRpdC90cmFpbGluZ3NwYWNlJ1xuaW1wb3J0ICdjb2RlbWlycm9yL2FkZG9uL2VkaXQvY2xvc2V0YWcnXG5pbXBvcnQgJ2NvZGVtaXJyb3IvYWRkb24vZGlzcGxheS9wbGFjZWhvbGRlcidcblxuaW1wb3J0ICogYXMgQ29kZU1pcnJvciBmcm9tICdjb2RlbWlycm9yJ1xuXG5pbXBvcnQgeyBDb21wb25lbnQsIGgsIHJlbmRlciB9IGZyb20gJ3ByZWFjdCdcbmltcG9ydCB7IE1PREVTLCBsb2FkTW9kZSB9IGZyb20gJ0BjaHVzcGFjZS9jb2RlLWVkaXRvci1tb2RlcydcblxuaW1wb3J0IENsaXBib2FyZEpTIGZyb20gJ2NsaXBib2FyZCdcbmltcG9ydCB7IEVkaXRvclZpZXcgfSBmcm9tICdwcm9zZW1pcnJvci12aWV3J1xuXG5jb25zdCBTVkdfUkFUSU8gPSAwLjgxXG5cbmNvbnN0IENvcHkgPSBwcm9wcyA9PiB7XG4gIGNvbnN0IHdpZHRoID0gU1ZHX1JBVElPICogMTZcblxuICByZXR1cm4gKFxuICAgIDxzdmdcbiAgICAgIGNsYXNzPVwiY29kZW1pcnJvci1jb3B5XCJcbiAgICAgIHdpZHRoPXt3aWR0aH1cbiAgICAgIGhlaWdodD17MTZ9XG4gICAgICB2aWV3Qm94PVwiMCAwIDEzIDE2XCJcbiAgICAgIGZpbGw9XCJub25lXCJcbiAgICAgIHhtbG5zPVwiaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmdcIlxuICAgID5cbiAgICAgIDxwYXRoXG4gICAgICAgIGQ9XCJNOCAwSDMuNDAzODVDMi41NTM4NSAwIDEuODQ2MTUgMC42NjkyMzEgMS44NDYxNSAxLjUxOTIzVjEuODQ2MTVIMS41NTc2OUMwLjcwNzY5MiAxLjg0NjE1IDAgMi41MTUzOCAwIDMuMzY1MzhWMTQuNDQyM0MwIDE1LjI5MjMgMC43MDc2OTIgMTYgMS41NTc2OSAxNkg5LjU1NzY5QzEwLjQwNzcgMTYgMTEuMDc2OSAxNS4yOTIzIDExLjA3NjkgMTQuNDQyM1YxNC4xNTM4SDExLjQwMzhDMTIuMjUzOCAxNC4xNTM4IDEyLjkyMzEgMTMuNDQ2MiAxMi45MjMxIDEyLjU5NjJWNC45MjMwOEw4IDBaTTggMS43MTUzOEwxMS4yMDc3IDQuOTIzMDhIOFYxLjcxNTM4Wk05Ljg0NjE1IDE0LjQ0MjNDOS44NDYxNSAxNC42MjMxIDkuNzE1MzggMTQuNzY5MiA5LjU1NzY5IDE0Ljc2OTJIMS41NTc2OUMxLjM4ODQ2IDE0Ljc2OTIgMS4yMzA3NyAxNC42MTE1IDEuMjMwNzcgMTQuNDQyM1YzLjM2NTM4QzEuMjMwNzcgMy4yMDc2OSAxLjM3NjkyIDMuMDc2OTIgMS41NTc2OSAzLjA3NjkySDEuODQ2MTVWMTIuOTAzOEMxLjg0NjE1IDEzLjc1MzggMi4yNDYxNSAxNC4xNTM4IDMuMDk2MTUgMTQuMTUzOEg5Ljg0NjE1VjE0LjQ0MjNaTTExLjY5MjMgMTIuNTk2MkMxMS42OTIzIDEyLjc3NjkgMTEuNTYxNSAxMi45MjMxIDExLjQwMzggMTIuOTIzMUgzLjQwMzg1QzMuMjM0NjIgMTIuOTIzMSAzLjA3NjkyIDEyLjc2NTQgMy4wNzY5MiAxMi41OTYyVjEuNTE5MjNDMy4wNzY5MiAxLjM2MTU0IDMuMjIzMDggMS4yMzA3NyAzLjQwMzg1IDEuMjMwNzdINi43NjkyM1Y2LjE1Mzg1SDExLjY5MjNWMTIuNTk2MlpcIlxuICAgICAgICBmaWxsPXsnYmxhY2snfVxuICAgICAgLz5cbiAgICA8L3N2Zz5cbiAgKVxufVxuXG5jb25zdCBDb250cm9scyA9IHByb3BzID0+IChcbiAgPHN2ZyBjbGFzcz1cImNvZGVtaXJyb3ItY29udHJvbHNcIiB4bWxucz1cImh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnXCIgd2lkdGg9XCI1NFwiIGhlaWdodD1cIjE0XCIgdmlld0JveD1cIjAgMCA1NCAxNFwiPlxuICAgIDxnIGZpbGw9XCJub25lXCIgZmlsbFJ1bGU9XCJldmVub2RkXCIgdHJhbnNmb3JtPVwidHJhbnNsYXRlKDEgMSlcIj5cbiAgICAgIDxjaXJjbGUgY3g9XCI2XCIgY3k9XCI2XCIgcj1cIjZcIiBmaWxsPVwiI0ZGNUY1NlwiIHN0cm9rZT1cIiNFMDQ0M0VcIiBzdHJva2VXaWR0aD1cIi41XCIgb25DbGljaz17cHJvcHMuZGVzdHJveX0gLz5cbiAgICAgIDxjaXJjbGUgY3g9XCIyNlwiIGN5PVwiNlwiIHI9XCI2XCIgZmlsbD1cIiNGRkJEMkVcIiBzdHJva2U9XCIjREVBMTIzXCIgc3Ryb2tlV2lkdGg9XCIuNVwiIC8+XG4gICAgICA8Y2lyY2xlIGN4PVwiNDZcIiBjeT1cIjZcIiByPVwiNlwiIGZpbGw9XCIjMjdDOTNGXCIgc3Ryb2tlPVwiIzFBQUIyOVwiIHN0cm9rZVdpZHRoPVwiLjVcIiAvPlxuICAgIDwvZz5cbiAgPC9zdmc+XG4pXG5cbnR5cGUgUHJvcHMgPSB7XG4gIG1vZGU6IHN0cmluZyxcbiAgc2V0TW9kZTogKG1vZGU6IHN0cmluZykgPT4gdm9pZFxufVxuXG50eXBlIFN0YXRlID0ge1xuICBtb2RlOiBzdHJpbmcsXG4gIHNob3dTd2l0Y2hlcjogYm9vbGVhblxufVxuXG5jbGFzcyBMYW5ndWFnZVN3aXRjaGVyIGV4dGVuZHMgQ29tcG9uZW50PFByb3BzLCBTdGF0ZT4ge1xuICBwcm9wczogRWRpdG9yVmlld1xuXG4gIGNvbnN0cnVjdG9yKHByb3BzKSB7XG4gICAgc3VwZXIocHJvcHMpXG5cbiAgICB0aGlzLnN0YXRlID0ge1xuICAgICAgbW9kZTogcHJvcHMubW9kZSxcbiAgICAgIHNob3dTd2l0Y2hlcjogZmFsc2VcbiAgICB9XG4gIH1cblxuICB0b2dnbGVTd2l0Y2hlciA9IGUgPT4ge1xuICAgIHRoaXMuc2V0U3RhdGUoe1xuICAgICAgc2hvd1N3aXRjaGVyOiAhdGhpcy5zdGF0ZS5zaG93U3dpdGNoZXJcbiAgICB9KVxuICB9XG5cbiAgaGFuZGxlTGFuZ3VhZ2VDaGFuZ2UgPSBlID0+IHtcbiAgICBlLnByZXZlbnREZWZhdWx0KClcblxuICAgIGNvbnN0IG1vZGUgPSBlLnRhcmdldC5kYXRhc2V0Lm1vZGVcbiAgICB0aGlzLnNldFN0YXRlKHsgbW9kZSwgc2hvd1N3aXRjaGVyOiBmYWxzZSB9KVxuICAgIHRoaXMucHJvcHMuc2V0TW9kZShtb2RlKVxuICB9XG5cbiAgcmVuZGVyKCkge1xuICAgIHJldHVybiAoXG4gICAgICA8ZGl2IGNsYXNzPVwiY29kZW1pcnJvci1sYW5ndWFnZS1zd2l0Y2hlci1jb250YWluZXJcIj5cbiAgICAgICAgPGlucHV0IHR5cGU9XCJ0ZXh0XCIgdmFsdWU9e3RoaXMuc3RhdGUubW9kZX0gY2xhc3M9XCJjb2RlbWlycm9yLWxhbmd1YWdlLWlucHV0XCIgb25Gb2N1cz17dGhpcy50b2dnbGVTd2l0Y2hlcn0gLz5cbiAgICAgICAge3RoaXMuc3RhdGUuc2hvd1N3aXRjaGVyICYmIChcbiAgICAgICAgICA8dWwgY2xhc3M9XCJjb2RlbWlycm9yLWxhbmd1YWdlLXN3aXRjaGVyXCI+XG4gICAgICAgICAgICB7TU9ERVMubWFwKCh7IG5hbWUsIG1vZGUgfSkgPT4gKFxuICAgICAgICAgICAgICA8bGkgb25DbGljaz17dGhpcy5oYW5kbGVMYW5ndWFnZUNoYW5nZX0gZGF0YS1tb2RlPXttb2RlfT5cbiAgICAgICAgICAgICAgICB7bmFtZX1cbiAgICAgICAgICAgICAgPC9saT5cbiAgICAgICAgICAgICkpfVxuICAgICAgICAgIDwvdWw+XG4gICAgICAgICl9XG4gICAgICA8L2Rpdj5cbiAgICApXG4gIH1cbn1cblxuY2xhc3MgVG9vbGJhciBleHRlbmRzIENvbXBvbmVudCB7XG4gIHZpZXc6IEVkaXRvclZpZXdcbiAgY2xpcGJvYXJkOiA/Q2xpcGJvYXJkSlNcbiAgc3dpdGNoZXI6ID9IVE1MRWxlbWVudFxuICBjb250cm9sczogP0hUTUxFbGVtZW50XG4gIGNvcHk6ID9IVE1MRWxlbWVudFxuXG4gIGNvbnN0cnVjdG9yKHByb3BzKSB7XG4gICAgc3VwZXIocHJvcHMpXG4gIH1cblxuICBpbml0Q2xpcGJvYXJkSlMgPSBub2RlID0+IG5ldyBDbGlwYm9hcmRKUyhub2RlKVxuXG4gIHJlbmRlcigpIHtcbiAgICByZXR1cm4gKFxuICAgICAgPGRpdiBjbGFzcz1cImNvZGVtaXJyb3ItdG9vbGJhclwiPlxuICAgICAgICA8Q29udHJvbHMgZGVzdHJveT17dGhpcy5wcm9wcy5kZXN0cm95fSAvPlxuICAgICAgICA8ZGl2IGNsYXNzPVwiY29kZW1pcnJvci10b29sYmFyLW1lbnVcIj5cbiAgICAgICAgICA8TGFuZ3VhZ2VTd2l0Y2hlciB7Li4udGhpcy5wcm9wc30gLz57JyAnfVxuICAgICAgICAgIDxkaXYgcmVmPXt0aGlzLmluaXRDbGlwYm9hcmRKU30gZGF0YS1jbGlwYm9hcmQtdGFyZ2V0PVwiLkNvZGVNaXJyb3ItY29kZVwiPlxuICAgICAgICAgICAgPENvcHkgLz5cbiAgICAgICAgICA8L2Rpdj5cbiAgICAgICAgPC9kaXY+XG4gICAgICA8L2Rpdj5cbiAgICApXG4gIH1cbn1cblxuZXhwb3J0IGRlZmF1bHQgY2xhc3MgQ29udGFpbmVyIGV4dGVuZHMgQ29tcG9uZW50IHtcbiAgY206ID9Db2RlTWlycm9yXG5cbiAgc2V0TW9kZSA9IGFzeW5jIChtb2RlOiBzdHJpbmcpID0+IHtcbiAgICBhd2FpdCBsb2FkTW9kZShtb2RlKVxuICAgIHRoaXMuY20gJiYgdGhpcy5jbS5zZXRPcHRpb24oJ21vZGUnLCBtb2RlKVxuICAgIHRoaXMucHJvcHMuaGFuZGxlTGFuZ3VhZ2VDaGFuZ2UgJiYgdGhpcy5wcm9wcy5oYW5kbGVMYW5ndWFnZUNoYW5nZShtb2RlKVxuICB9XG5cbiAgY3JlYXRlQ00gPSAobm9kZTogP0hUTUxFbGVtZW50KSA9PiB7XG4gICAgdGhpcy5jbSA9IG5ldyBDb2RlTWlycm9yKG5vZGUsIHtcbiAgICAgIHZhbHVlOiB0aGlzLnByb3BzLmNvbnRlbnQsXG4gICAgICBsaW5lTnVtYmVyczogdHJ1ZSxcbiAgICAgIHNtYXJ0SW5kZW50OiAhdGhpcy5wcm9wcy5yZWFkT25seSxcbiAgICAgIHJlYWRPbmx5OiB0aGlzLnByb3BzLnJlYWRPbmx5IHx8IGZhbHNlLFxuICAgICAgbW9kZTogdGhpcy5wcm9wcy5tb2RlLFxuICAgICAgaW5kZW50V2l0aFRhYnM6ICF0aGlzLnByb3BzLnJlYWRPbmx5LFxuICAgICAgdGhlbWU6ICdvbmUtbGlnaHQnLFxuICAgICAgYXV0b2ZvY3VzOiAhdGhpcy5wcm9wcy5yZWFkT25seSxcbiAgICAgIGFkZE1vZGVDbGFzczogdHJ1ZSxcbiAgICAgIGxpbmVXcmFwcGluZzogdHJ1ZSxcbiAgICAgIGF1dG9DbG9zZUJyYWNrZXRzOiB0cnVlLFxuICAgICAgYXV0b0Nsb3NlVGFnczogdHJ1ZSxcbiAgICAgIHNob3dUcmFpbGluZ1NwYWNlOiB0cnVlLFxuICAgICAgbWF0Y2hUYWdzOiB0cnVlLFxuICAgICAgcGxhY2Vob2xkZXI6IGBTdGFydCB3cml0aW5nICR7dGhpcy5wcm9wcy5tb2RlfSBjb2RlLi4uYCxcbiAgICAgIGV4dHJhS2V5czogdGhpcy5wcm9wcy5jb2RlTWlycm9yS2V5bWFwICYmIHRoaXMucHJvcHMuY29kZU1pcnJvcktleW1hcCgpXG4gICAgfSlcblxuICAgIHRoaXMucHJvcHMuZ2V0Q01JbnN0YW5jZSh0aGlzLmNtKVxuICAgIHRoaXMuc2V0TW9kZSh0aGlzLnByb3BzLm1vZGUpXG4gIH1cblxuICByZW5kZXIgPSAoKSA9PiB7XG4gICAgcmV0dXJuIChcbiAgICAgIDxkaXYgY2xhc3M9XCJjb2RlbWlycm9yLWNvbnRhaW5lclwiIGNvbnRlbnRFZGl0YWJsZT17ZmFsc2V9PlxuICAgICAgICA8VG9vbGJhciB7Li4udGhpcy5wcm9wc30gc2V0TW9kZT17dGhpcy5zZXRNb2RlfSAvPlxuICAgICAgICA8c3BhbiByZWY9e3RoaXMuY3JlYXRlQ019IC8+XG4gICAgICA8L2Rpdj5cbiAgICApXG4gIH1cbn1cbiJdfQ==