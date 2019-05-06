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

var StrikeThrough =
/*#__PURE__*/
function (_Mark) {
  _inherits(StrikeThrough, _Mark);

  function StrikeThrough() {
    var _getPrototypeOf2;

    var _this;

    _classCallCheck(this, StrikeThrough);

    for (var _len = arguments.length, args = new Array(_len), _key = 0; _key < _len; _key++) {
      args[_key] = arguments[_key];
    }

    _this = _possibleConstructorReturn(this, (_getPrototypeOf2 = _getPrototypeOf(StrikeThrough)).call.apply(_getPrototypeOf2, [this].concat(args)));
    _this.name = 'strike_through';
    return _this;
  }

  _createClass(StrikeThrough, [{
    key: "keys",
    value: function keys(_ref) {
      var type = _ref.type;
      return {
        'Mod-d': toggleMark(type)
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
      return [markInputRule(/~([^~]+)~$/, type)];
    }
  }, {
    key: "pasteRules",
    value: function pasteRules(_ref4) {
      var type = _ref4.type;
      return [markPasteRule(/~([^~]+)~/g, type)];
    }
  }, {
    key: "schema",
    get: function get() {
      return {
        parseDOM: [{
          tag: 's'
        }, {
          tag: 'del'
        }, {
          tag: 'strike'
        }, {
          style: 'text-decoration',
          getAttrs: function getAttrs(value) {
            return value === 'line-through';
          }
        }],
        toDOM: function toDOM() {
          return ['s', 0];
        }
      };
    }
  }]);

  return StrikeThrough;
}(Mark);

export { StrikeThrough as default };
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uL2xpYi9tYXJrcy9zdHJpa2UtdGhyb3VnaC5qcyJdLCJuYW1lcyI6WyJtYXJrSW5wdXRSdWxlIiwibWFya1Bhc3RlUnVsZSIsIk1hcmsiLCJQTU1hcmsiLCJ0b2dnbGVNYXJrIiwiU3RyaWtlVGhyb3VnaCIsIm5hbWUiLCJ0eXBlIiwicGFyc2VET00iLCJ0YWciLCJzdHlsZSIsImdldEF0dHJzIiwidmFsdWUiLCJ0b0RPTSJdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7Ozs7Ozs7OztBQUVBLFNBQVNBLGFBQVQsRUFBd0JDLGFBQXhCLFFBQTZDLDJCQUE3QztBQUVBLFNBQVNDLElBQVQsUUFBcUIsdUJBQXJCO0FBQ0EsU0FBU0EsSUFBSSxJQUFJQyxNQUFqQixRQUErQixtQkFBL0I7QUFDQSxTQUFTQyxVQUFULFFBQTJCLHNCQUEzQjs7SUFFcUJDLGE7Ozs7Ozs7Ozs7Ozs7Ozs7O1VBQ25CQyxJLEdBQU8sZ0I7Ozs7OzsrQkF1QmdCO0FBQUEsVUFBaEJDLElBQWdCLFFBQWhCQSxJQUFnQjtBQUNyQixhQUFPO0FBQ0wsaUJBQVNILFVBQVUsQ0FBQ0csSUFBRDtBQURkLE9BQVA7QUFHRDs7O29DQUUwQjtBQUFBLFVBQWhCQSxJQUFnQixTQUFoQkEsSUFBZ0I7QUFDekIsYUFBTztBQUFBLGVBQU1ILFVBQVUsQ0FBQ0csSUFBRCxDQUFoQjtBQUFBLE9BQVA7QUFDRDs7O3NDQUU0QjtBQUFBLFVBQWhCQSxJQUFnQixTQUFoQkEsSUFBZ0I7QUFDM0IsYUFBTyxDQUFDUCxhQUFhLENBQUMsWUFBRCxFQUFlTyxJQUFmLENBQWQsQ0FBUDtBQUNEOzs7c0NBRTRCO0FBQUEsVUFBaEJBLElBQWdCLFNBQWhCQSxJQUFnQjtBQUMzQixhQUFPLENBQUNOLGFBQWEsQ0FBQyxZQUFELEVBQWVNLElBQWYsQ0FBZCxDQUFQO0FBQ0Q7Ozt3QkFyQ1k7QUFDWCxhQUFPO0FBQ0xDLFFBQUFBLFFBQVEsRUFBRSxDQUNSO0FBQ0VDLFVBQUFBLEdBQUcsRUFBRTtBQURQLFNBRFEsRUFJUjtBQUNFQSxVQUFBQSxHQUFHLEVBQUU7QUFEUCxTQUpRLEVBT1I7QUFDRUEsVUFBQUEsR0FBRyxFQUFFO0FBRFAsU0FQUSxFQVVSO0FBQ0VDLFVBQUFBLEtBQUssRUFBRSxpQkFEVDtBQUVFQyxVQUFBQSxRQUFRLEVBQUUsa0JBQUNDLEtBQUQ7QUFBQSxtQkFBbUJBLEtBQUssS0FBSyxjQUE3QjtBQUFBO0FBRlosU0FWUSxDQURMO0FBZ0JMQyxRQUFBQSxLQUFLLEVBQUU7QUFBQSxpQkFBTSxDQUFDLEdBQUQsRUFBTSxDQUFOLENBQU47QUFBQTtBQWhCRixPQUFQO0FBa0JEOzs7O0VBdEJ3Q1gsSTs7U0FBdEJHLGEiLCJzb3VyY2VzQ29udGVudCI6WyIvLyBAZmxvd1xuXG5pbXBvcnQgeyBtYXJrSW5wdXRSdWxlLCBtYXJrUGFzdGVSdWxlIH0gZnJvbSAnQGNodXNwYWNlL2VkaXRvci1jb21tYW5kcydcblxuaW1wb3J0IHsgTWFyayB9IGZyb20gJ0BjaHVzcGFjZS9lZGl0b3ItYmFzZSdcbmltcG9ydCB7IE1hcmsgYXMgUE1NYXJrIH0gZnJvbSAncHJvc2VtaXJyb3ItbW9kZWwnXG5pbXBvcnQgeyB0b2dnbGVNYXJrIH0gZnJvbSAncHJvc2VtaXJyb3ItY29tbWFuZHMnXG5cbmV4cG9ydCBkZWZhdWx0IGNsYXNzIFN0cmlrZVRocm91Z2ggZXh0ZW5kcyBNYXJrIHtcbiAgbmFtZSA9ICdzdHJpa2VfdGhyb3VnaCdcblxuICBnZXQgc2NoZW1hKCkge1xuICAgIHJldHVybiB7XG4gICAgICBwYXJzZURPTTogW1xuICAgICAgICB7XG4gICAgICAgICAgdGFnOiAncydcbiAgICAgICAgfSxcbiAgICAgICAge1xuICAgICAgICAgIHRhZzogJ2RlbCdcbiAgICAgICAgfSxcbiAgICAgICAge1xuICAgICAgICAgIHRhZzogJ3N0cmlrZSdcbiAgICAgICAgfSxcbiAgICAgICAge1xuICAgICAgICAgIHN0eWxlOiAndGV4dC1kZWNvcmF0aW9uJyxcbiAgICAgICAgICBnZXRBdHRyczogKHZhbHVlOiBzdHJpbmcpID0+IHZhbHVlID09PSAnbGluZS10aHJvdWdoJ1xuICAgICAgICB9XG4gICAgICBdLFxuICAgICAgdG9ET006ICgpID0+IFsncycsIDBdXG4gICAgfVxuICB9XG5cbiAga2V5cyh7IHR5cGUgfTogUE1NYXJrKSB7XG4gICAgcmV0dXJuIHtcbiAgICAgICdNb2QtZCc6IHRvZ2dsZU1hcmsodHlwZSlcbiAgICB9XG4gIH1cblxuICBjb21tYW5kcyh7IHR5cGUgfTogUE1NYXJrKSB7XG4gICAgcmV0dXJuICgpID0+IHRvZ2dsZU1hcmsodHlwZSlcbiAgfVxuXG4gIGlucHV0UnVsZXMoeyB0eXBlIH06IFBNTWFyaykge1xuICAgIHJldHVybiBbbWFya0lucHV0UnVsZSgvfihbXn5dKyl+JC8sIHR5cGUpXVxuICB9XG5cbiAgcGFzdGVSdWxlcyh7IHR5cGUgfTogUE1NYXJrKSB7XG4gICAgcmV0dXJuIFttYXJrUGFzdGVSdWxlKC9+KFtefl0rKX4vZywgdHlwZSldXG4gIH1cbn1cbiJdfQ==