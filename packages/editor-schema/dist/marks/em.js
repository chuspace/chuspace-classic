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

var Em =
/*#__PURE__*/
function (_Mark) {
  _inherits(Em, _Mark);

  function Em() {
    var _getPrototypeOf2;

    var _this;

    _classCallCheck(this, Em);

    for (var _len = arguments.length, args = new Array(_len), _key = 0; _key < _len; _key++) {
      args[_key] = arguments[_key];
    }

    _this = _possibleConstructorReturn(this, (_getPrototypeOf2 = _getPrototypeOf(Em)).call.apply(_getPrototypeOf2, [this].concat(args)));
    _this.name = 'em';
    return _this;
  }

  _createClass(Em, [{
    key: "keys",
    value: function keys(_ref) {
      var type = _ref.type;
      return {
        'Mod-i': toggleMark(type)
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
      return [markInputRule(/(?:^|[^*_])(?:\*|_)([^*_]+)(?:\*|_)$/, type)];
    }
  }, {
    key: "pasteRules",
    value: function pasteRules(_ref4) {
      var type = _ref4.type;
      return [markPasteRule(/(?:^|[^*_])(?:\*|_)([^*_]+)(?:\*|_)/g, type)];
    }
  }, {
    key: "schema",
    get: function get() {
      return {
        parseDOM: [{
          tag: 'i'
        }, {
          tag: 'em'
        }, {
          style: 'font-style=italic'
        }],
        toDOM: function toDOM() {
          return ['em', 0];
        }
      };
    }
  }]);

  return Em;
}(Mark);

export { Em as default };
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uL2xpYi9tYXJrcy9lbS5qcyJdLCJuYW1lcyI6WyJtYXJrSW5wdXRSdWxlIiwibWFya1Bhc3RlUnVsZSIsIk1hcmsiLCJQTU1hcmsiLCJ0b2dnbGVNYXJrIiwiRW0iLCJuYW1lIiwidHlwZSIsInBhcnNlRE9NIiwidGFnIiwic3R5bGUiLCJ0b0RPTSJdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7Ozs7Ozs7OztBQUVBLFNBQVNBLGFBQVQsRUFBd0JDLGFBQXhCLFFBQTZDLDJCQUE3QztBQUVBLFNBQVNDLElBQVQsUUFBcUIsdUJBQXJCO0FBQ0EsU0FBU0EsSUFBSSxJQUFJQyxNQUFqQixRQUErQixtQkFBL0I7QUFDQSxTQUFTQyxVQUFULFFBQTJCLHNCQUEzQjs7SUFFcUJDLEU7Ozs7Ozs7Ozs7Ozs7Ozs7O1VBQ25CQyxJLEdBQU8sSTs7Ozs7OytCQVNnQjtBQUFBLFVBQWhCQyxJQUFnQixRQUFoQkEsSUFBZ0I7QUFDckIsYUFBTztBQUNMLGlCQUFTSCxVQUFVLENBQUNHLElBQUQ7QUFEZCxPQUFQO0FBR0Q7OztvQ0FFMEI7QUFBQSxVQUFoQkEsSUFBZ0IsU0FBaEJBLElBQWdCO0FBQ3pCLGFBQU87QUFBQSxlQUFNSCxVQUFVLENBQUNHLElBQUQsQ0FBaEI7QUFBQSxPQUFQO0FBQ0Q7OztzQ0FFNEI7QUFBQSxVQUFoQkEsSUFBZ0IsU0FBaEJBLElBQWdCO0FBQzNCLGFBQU8sQ0FBQ1AsYUFBYSxDQUFDLHNDQUFELEVBQXlDTyxJQUF6QyxDQUFkLENBQVA7QUFDRDs7O3NDQUU0QjtBQUFBLFVBQWhCQSxJQUFnQixTQUFoQkEsSUFBZ0I7QUFDM0IsYUFBTyxDQUFDTixhQUFhLENBQUMsc0NBQUQsRUFBeUNNLElBQXpDLENBQWQsQ0FBUDtBQUNEOzs7d0JBdkJZO0FBQ1gsYUFBTztBQUNMQyxRQUFBQSxRQUFRLEVBQUUsQ0FBQztBQUFFQyxVQUFBQSxHQUFHLEVBQUU7QUFBUCxTQUFELEVBQWU7QUFBRUEsVUFBQUEsR0FBRyxFQUFFO0FBQVAsU0FBZixFQUE4QjtBQUFFQyxVQUFBQSxLQUFLLEVBQUU7QUFBVCxTQUE5QixDQURMO0FBRUxDLFFBQUFBLEtBQUssRUFBRTtBQUFBLGlCQUFNLENBQUMsSUFBRCxFQUFPLENBQVAsQ0FBTjtBQUFBO0FBRkYsT0FBUDtBQUlEOzs7O0VBUjZCVCxJOztTQUFYRyxFIiwic291cmNlc0NvbnRlbnQiOlsiLy8gQGZsb3dcblxuaW1wb3J0IHsgbWFya0lucHV0UnVsZSwgbWFya1Bhc3RlUnVsZSB9IGZyb20gJ0BjaHVzcGFjZS9lZGl0b3ItY29tbWFuZHMnXG5cbmltcG9ydCB7IE1hcmsgfSBmcm9tICdAY2h1c3BhY2UvZWRpdG9yLWJhc2UnXG5pbXBvcnQgeyBNYXJrIGFzIFBNTWFyayB9IGZyb20gJ3Byb3NlbWlycm9yLW1vZGVsJ1xuaW1wb3J0IHsgdG9nZ2xlTWFyayB9IGZyb20gJ3Byb3NlbWlycm9yLWNvbW1hbmRzJ1xuXG5leHBvcnQgZGVmYXVsdCBjbGFzcyBFbSBleHRlbmRzIE1hcmsge1xuICBuYW1lID0gJ2VtJ1xuXG4gIGdldCBzY2hlbWEoKSB7XG4gICAgcmV0dXJuIHtcbiAgICAgIHBhcnNlRE9NOiBbeyB0YWc6ICdpJyB9LCB7IHRhZzogJ2VtJyB9LCB7IHN0eWxlOiAnZm9udC1zdHlsZT1pdGFsaWMnIH1dLFxuICAgICAgdG9ET006ICgpID0+IFsnZW0nLCAwXVxuICAgIH1cbiAgfVxuXG4gIGtleXMoeyB0eXBlIH06IFBNTWFyaykge1xuICAgIHJldHVybiB7XG4gICAgICAnTW9kLWknOiB0b2dnbGVNYXJrKHR5cGUpXG4gICAgfVxuICB9XG5cbiAgY29tbWFuZHMoeyB0eXBlIH06IFBNTWFyaykge1xuICAgIHJldHVybiAoKSA9PiB0b2dnbGVNYXJrKHR5cGUpXG4gIH1cblxuICBpbnB1dFJ1bGVzKHsgdHlwZSB9OiBQTU1hcmspIHtcbiAgICByZXR1cm4gW21hcmtJbnB1dFJ1bGUoLyg/Ol58W14qX10pKD86XFwqfF8pKFteKl9dKykoPzpcXCp8XykkLywgdHlwZSldXG4gIH1cblxuICBwYXN0ZVJ1bGVzKHsgdHlwZSB9OiBQTU1hcmspIHtcbiAgICByZXR1cm4gW21hcmtQYXN0ZVJ1bGUoLyg/Ol58W14qX10pKD86XFwqfF8pKFteKl9dKykoPzpcXCp8XykvZywgdHlwZSldXG4gIH1cbn1cbiJdfQ==