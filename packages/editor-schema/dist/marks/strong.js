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
import { Node } from 'prosemirror-model';
import { Mark as PMMark } from 'prosemirror-model';
import { toggleMark } from 'prosemirror-commands';

var Strong =
/*#__PURE__*/
function (_Mark) {
  _inherits(Strong, _Mark);

  function Strong() {
    var _getPrototypeOf2;

    var _this;

    _classCallCheck(this, Strong);

    for (var _len = arguments.length, args = new Array(_len), _key = 0; _key < _len; _key++) {
      args[_key] = arguments[_key];
    }

    _this = _possibleConstructorReturn(this, (_getPrototypeOf2 = _getPrototypeOf(Strong)).call.apply(_getPrototypeOf2, [this].concat(args)));
    _this.name = 'strong';
    return _this;
  }

  _createClass(Strong, [{
    key: "keys",
    value: function keys(_ref) {
      var type = _ref.type;
      return {
        'Mod-b': toggleMark(type)
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
      return [markInputRule(/(?:\*\*|__)([^*_]+)(?:\*\*|__)$/, type)];
    }
  }, {
    key: "pasteRules",
    value: function pasteRules(_ref4) {
      var type = _ref4.type;
      return [markPasteRule(/(?:\*\*|__)([^*_]+)(?:\*\*|__)/g, type)];
    }
  }, {
    key: "schema",
    get: function get() {
      return {
        parseDOM: [{
          tag: 'strong'
        }, {
          tag: 'b',
          getAttrs: function getAttrs(mark) {
            return mark.style.fontWeight !== 'normal' && null;
          }
        }, {
          style: 'font-weight',
          getAttrs: function getAttrs(value) {
            return /^(bold(er)?|[5-9]\d{2,})$/.test(value) && null;
          }
        }],
        toDOM: function toDOM() {
          return ['strong', 0];
        }
      };
    }
  }]);

  return Strong;
}(Mark);

export { Strong as default };
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uL2xpYi9tYXJrcy9zdHJvbmcuanMiXSwibmFtZXMiOlsibWFya0lucHV0UnVsZSIsIm1hcmtQYXN0ZVJ1bGUiLCJNYXJrIiwiTm9kZSIsIlBNTWFyayIsInRvZ2dsZU1hcmsiLCJTdHJvbmciLCJuYW1lIiwidHlwZSIsInBhcnNlRE9NIiwidGFnIiwiZ2V0QXR0cnMiLCJtYXJrIiwic3R5bGUiLCJmb250V2VpZ2h0IiwidmFsdWUiLCJ0ZXN0IiwidG9ET00iXSwibWFwcGluZ3MiOiI7Ozs7Ozs7Ozs7Ozs7Ozs7QUFFQSxTQUFTQSxhQUFULEVBQXdCQyxhQUF4QixRQUE2QywyQkFBN0M7QUFFQSxTQUFTQyxJQUFULFFBQXFCLHVCQUFyQjtBQUNBLFNBQVNDLElBQVQsUUFBcUIsbUJBQXJCO0FBQ0EsU0FBU0QsSUFBSSxJQUFJRSxNQUFqQixRQUErQixtQkFBL0I7QUFDQSxTQUFTQyxVQUFULFFBQTJCLHNCQUEzQjs7SUFFcUJDLE07Ozs7Ozs7Ozs7Ozs7Ozs7O1VBQ25CQyxJLEdBQU8sUTs7Ozs7OytCQXFCZ0I7QUFBQSxVQUFoQkMsSUFBZ0IsUUFBaEJBLElBQWdCO0FBQ3JCLGFBQU87QUFDTCxpQkFBU0gsVUFBVSxDQUFDRyxJQUFEO0FBRGQsT0FBUDtBQUdEOzs7b0NBRTBCO0FBQUEsVUFBaEJBLElBQWdCLFNBQWhCQSxJQUFnQjtBQUN6QixhQUFPO0FBQUEsZUFBTUgsVUFBVSxDQUFDRyxJQUFELENBQWhCO0FBQUEsT0FBUDtBQUNEOzs7c0NBRTRCO0FBQUEsVUFBaEJBLElBQWdCLFNBQWhCQSxJQUFnQjtBQUMzQixhQUFPLENBQUNSLGFBQWEsQ0FBQyxpQ0FBRCxFQUFvQ1EsSUFBcEMsQ0FBZCxDQUFQO0FBQ0Q7OztzQ0FFNEI7QUFBQSxVQUFoQkEsSUFBZ0IsU0FBaEJBLElBQWdCO0FBQzNCLGFBQU8sQ0FBQ1AsYUFBYSxDQUFDLGlDQUFELEVBQW9DTyxJQUFwQyxDQUFkLENBQVA7QUFDRDs7O3dCQW5DWTtBQUNYLGFBQU87QUFDTEMsUUFBQUEsUUFBUSxFQUFFLENBQ1I7QUFDRUMsVUFBQUEsR0FBRyxFQUFFO0FBRFAsU0FEUSxFQUlSO0FBQ0VBLFVBQUFBLEdBQUcsRUFBRSxHQURQO0FBRUVDLFVBQUFBLFFBQVEsRUFBRSxrQkFBQ0MsSUFBRDtBQUFBLG1CQUFrQkEsSUFBSSxDQUFDQyxLQUFMLENBQVdDLFVBQVgsS0FBMEIsUUFBMUIsSUFBc0MsSUFBeEQ7QUFBQTtBQUZaLFNBSlEsRUFRUjtBQUNFRCxVQUFBQSxLQUFLLEVBQUUsYUFEVDtBQUVFRixVQUFBQSxRQUFRLEVBQUUsa0JBQUNJLEtBQUQ7QUFBQSxtQkFBbUIsNEJBQTRCQyxJQUE1QixDQUFpQ0QsS0FBakMsS0FBMkMsSUFBOUQ7QUFBQTtBQUZaLFNBUlEsQ0FETDtBQWNMRSxRQUFBQSxLQUFLLEVBQUU7QUFBQSxpQkFBTSxDQUFDLFFBQUQsRUFBVyxDQUFYLENBQU47QUFBQTtBQWRGLE9BQVA7QUFnQkQ7Ozs7RUFwQmlDZixJOztTQUFmSSxNIiwic291cmNlc0NvbnRlbnQiOlsiLy8gQGZsb3dcblxuaW1wb3J0IHsgbWFya0lucHV0UnVsZSwgbWFya1Bhc3RlUnVsZSB9IGZyb20gJ0BjaHVzcGFjZS9lZGl0b3ItY29tbWFuZHMnXG5cbmltcG9ydCB7IE1hcmsgfSBmcm9tICdAY2h1c3BhY2UvZWRpdG9yLWJhc2UnXG5pbXBvcnQgeyBOb2RlIH0gZnJvbSAncHJvc2VtaXJyb3ItbW9kZWwnXG5pbXBvcnQgeyBNYXJrIGFzIFBNTWFyayB9IGZyb20gJ3Byb3NlbWlycm9yLW1vZGVsJ1xuaW1wb3J0IHsgdG9nZ2xlTWFyayB9IGZyb20gJ3Byb3NlbWlycm9yLWNvbW1hbmRzJ1xuXG5leHBvcnQgZGVmYXVsdCBjbGFzcyBTdHJvbmcgZXh0ZW5kcyBNYXJrIHtcbiAgbmFtZSA9ICdzdHJvbmcnXG5cbiAgZ2V0IHNjaGVtYSgpIHtcbiAgICByZXR1cm4ge1xuICAgICAgcGFyc2VET006IFtcbiAgICAgICAge1xuICAgICAgICAgIHRhZzogJ3N0cm9uZydcbiAgICAgICAgfSxcbiAgICAgICAge1xuICAgICAgICAgIHRhZzogJ2InLFxuICAgICAgICAgIGdldEF0dHJzOiAobWFyazogUE1NYXJrKSA9PiBtYXJrLnN0eWxlLmZvbnRXZWlnaHQgIT09ICdub3JtYWwnICYmIG51bGxcbiAgICAgICAgfSxcbiAgICAgICAge1xuICAgICAgICAgIHN0eWxlOiAnZm9udC13ZWlnaHQnLFxuICAgICAgICAgIGdldEF0dHJzOiAodmFsdWU6IHN0cmluZykgPT4gL14oYm9sZChlcik/fFs1LTldXFxkezIsfSkkLy50ZXN0KHZhbHVlKSAmJiBudWxsXG4gICAgICAgIH1cbiAgICAgIF0sXG4gICAgICB0b0RPTTogKCkgPT4gWydzdHJvbmcnLCAwXVxuICAgIH1cbiAgfVxuXG4gIGtleXMoeyB0eXBlIH06IFBNTWFyaykge1xuICAgIHJldHVybiB7XG4gICAgICAnTW9kLWInOiB0b2dnbGVNYXJrKHR5cGUpXG4gICAgfVxuICB9XG5cbiAgY29tbWFuZHMoeyB0eXBlIH06IFBNTWFyaykge1xuICAgIHJldHVybiAoKSA9PiB0b2dnbGVNYXJrKHR5cGUpXG4gIH1cblxuICBpbnB1dFJ1bGVzKHsgdHlwZSB9OiBQTU1hcmspIHtcbiAgICByZXR1cm4gW21hcmtJbnB1dFJ1bGUoLyg/OlxcKlxcKnxfXykoW14qX10rKSg/OlxcKlxcKnxfXykkLywgdHlwZSldXG4gIH1cblxuICBwYXN0ZVJ1bGVzKHsgdHlwZSB9OiBQTU1hcmspIHtcbiAgICByZXR1cm4gW21hcmtQYXN0ZVJ1bGUoLyg/OlxcKlxcKnxfXykoW14qX10rKSg/OlxcKlxcKnxfXykvZywgdHlwZSldXG4gIH1cbn1cbiJdfQ==