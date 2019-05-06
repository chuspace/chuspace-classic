function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

function _possibleConstructorReturn(self, call) { if (call && (typeof call === "object" || typeof call === "function")) { return call; } return _assertThisInitialized(self); }

function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }

function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); if (superClass) _setPrototypeOf(subClass, superClass); }

function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf || function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }

import { markInputRule, markPasteRule } from '@chuspace/editor-commands';
import { Mark } from '@chuspace/editor-base';
import { Mark as PMMark } from 'prosemirror-model';
import { toggleMark } from 'prosemirror-commands';

var Code =
/*#__PURE__*/
function (_Mark) {
  _inherits(Code, _Mark);

  function Code() {
    var _getPrototypeOf2;

    var _this;

    _classCallCheck(this, Code);

    for (var _len = arguments.length, args = new Array(_len), _key = 0; _key < _len; _key++) {
      args[_key] = arguments[_key];
    }

    _this = _possibleConstructorReturn(this, (_getPrototypeOf2 = _getPrototypeOf(Code)).call.apply(_getPrototypeOf2, [this].concat(args)));
    _this.name = 'code';
    return _this;
  }

  _createClass(Code, [{
    key: "keys",
    value: function keys(_ref) {
      var type = _ref.type;
      return {
        'Mod-`': toggleMark(type)
      };
    }
  }, {
    key: "commands",
    value: function commands(_ref2) {
      var type = _ref2.type;
      return function () {
        return toggleMark(type);
      };
    }
  }, {
    key: "inputRules",
    value: function inputRules(_ref3) {
      var type = _ref3.type;
      return [markInputRule(/(?:`)([^`]+)(?:`)$/, type)];
    }
  }, {
    key: "pasteRules",
    value: function pasteRules(_ref4) {
      var type = _ref4.type;
      return [markPasteRule(/(?:`)([^`]+)(?:`)/g, type)];
    }
  }, {
    key: "schema",
    get: function get() {
      return {
        parseDOM: [{
          tag: 'code'
        }],
        toDOM: function toDOM() {
          return ['code', 0];
        }
      };
    }
  }]);

  return Code;
}(Mark);

export { Code as default };
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uL2xpYi9tYXJrcy9jb2RlLmpzIl0sIm5hbWVzIjpbIm1hcmtJbnB1dFJ1bGUiLCJtYXJrUGFzdGVSdWxlIiwiTWFyayIsIlBNTWFyayIsInRvZ2dsZU1hcmsiLCJDb2RlIiwibmFtZSIsInR5cGUiLCJwYXJzZURPTSIsInRhZyIsInRvRE9NIl0sIm1hcHBpbmdzIjoiOzs7Ozs7Ozs7Ozs7Ozs7O0FBRUEsU0FBU0EsYUFBVCxFQUF3QkMsYUFBeEIsUUFBNkMsMkJBQTdDO0FBRUEsU0FBU0MsSUFBVCxRQUFxQix1QkFBckI7QUFDQSxTQUFTQSxJQUFJLElBQUlDLE1BQWpCLFFBQStCLG1CQUEvQjtBQUNBLFNBQVNDLFVBQVQsUUFBMkIsc0JBQTNCOztJQUVxQkMsSTs7Ozs7Ozs7Ozs7Ozs7Ozs7VUFDbkJDLEksR0FBTyxNOzs7Ozs7K0JBU2dCO0FBQUEsVUFBaEJDLElBQWdCLFFBQWhCQSxJQUFnQjtBQUNyQixhQUFPO0FBQ0wsaUJBQVNILFVBQVUsQ0FBQ0csSUFBRDtBQURkLE9BQVA7QUFHRDs7O29DQUUwQjtBQUFBLFVBQWhCQSxJQUFnQixTQUFoQkEsSUFBZ0I7QUFDekIsYUFBTztBQUFBLGVBQU1ILFVBQVUsQ0FBQ0csSUFBRCxDQUFoQjtBQUFBLE9BQVA7QUFDRDs7O3NDQUU0QjtBQUFBLFVBQWhCQSxJQUFnQixTQUFoQkEsSUFBZ0I7QUFDM0IsYUFBTyxDQUFDUCxhQUFhLENBQUMsb0JBQUQsRUFBdUJPLElBQXZCLENBQWQsQ0FBUDtBQUNEOzs7c0NBRTRCO0FBQUEsVUFBaEJBLElBQWdCLFNBQWhCQSxJQUFnQjtBQUMzQixhQUFPLENBQUNOLGFBQWEsQ0FBQyxvQkFBRCxFQUF1Qk0sSUFBdkIsQ0FBZCxDQUFQO0FBQ0Q7Ozt3QkF2Qlk7QUFDWCxhQUFPO0FBQ0xDLFFBQUFBLFFBQVEsRUFBRSxDQUFDO0FBQUVDLFVBQUFBLEdBQUcsRUFBRTtBQUFQLFNBQUQsQ0FETDtBQUVMQyxRQUFBQSxLQUFLLEVBQUU7QUFBQSxpQkFBTSxDQUFDLE1BQUQsRUFBUyxDQUFULENBQU47QUFBQTtBQUZGLE9BQVA7QUFJRDs7OztFQVIrQlIsSTs7U0FBYkcsSSIsInNvdXJjZXNDb250ZW50IjpbIi8vIEBmbG93XG5cbmltcG9ydCB7IG1hcmtJbnB1dFJ1bGUsIG1hcmtQYXN0ZVJ1bGUgfSBmcm9tICdAY2h1c3BhY2UvZWRpdG9yLWNvbW1hbmRzJ1xuXG5pbXBvcnQgeyBNYXJrIH0gZnJvbSAnQGNodXNwYWNlL2VkaXRvci1iYXNlJ1xuaW1wb3J0IHsgTWFyayBhcyBQTU1hcmsgfSBmcm9tICdwcm9zZW1pcnJvci1tb2RlbCdcbmltcG9ydCB7IHRvZ2dsZU1hcmsgfSBmcm9tICdwcm9zZW1pcnJvci1jb21tYW5kcydcblxuZXhwb3J0IGRlZmF1bHQgY2xhc3MgQ29kZSBleHRlbmRzIE1hcmsge1xuICBuYW1lID0gJ2NvZGUnXG5cbiAgZ2V0IHNjaGVtYSgpIHtcbiAgICByZXR1cm4ge1xuICAgICAgcGFyc2VET006IFt7IHRhZzogJ2NvZGUnIH1dLFxuICAgICAgdG9ET006ICgpID0+IFsnY29kZScsIDBdXG4gICAgfVxuICB9XG5cbiAga2V5cyh7IHR5cGUgfTogUE1NYXJrKSB7XG4gICAgcmV0dXJuIHtcbiAgICAgICdNb2QtYCc6IHRvZ2dsZU1hcmsodHlwZSlcbiAgICB9XG4gIH1cblxuICBjb21tYW5kcyh7IHR5cGUgfTogUE1NYXJrKSB7XG4gICAgcmV0dXJuICgpID0+IHRvZ2dsZU1hcmsodHlwZSlcbiAgfVxuXG4gIGlucHV0UnVsZXMoeyB0eXBlIH06IFBNTWFyaykge1xuICAgIHJldHVybiBbbWFya0lucHV0UnVsZSgvKD86YCkoW15gXSspKD86YCkkLywgdHlwZSldXG4gIH1cblxuICBwYXN0ZVJ1bGVzKHsgdHlwZSB9OiBQTU1hcmspIHtcbiAgICByZXR1cm4gW21hcmtQYXN0ZVJ1bGUoLyg/OmApKFteYF0rKSg/OmApL2csIHR5cGUpXVxuICB9XG59XG4iXX0=