function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

function _possibleConstructorReturn(self, call) { if (call && (typeof call === "object" || typeof call === "function")) { return call; } return _assertThisInitialized(self); }

function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }

function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); if (superClass) _setPrototypeOf(subClass, superClass); }

function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf || function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }

import { liftListItem, sinkListItem, splitListItem } from 'prosemirror-schema-list';
import { Node } from '@chuspace/editor-base';
import { Node as PMNode } from 'prosemirror-model';

var ListItem =
/*#__PURE__*/
function (_Node) {
  _inherits(ListItem, _Node);

  function ListItem() {
    var _getPrototypeOf2;

    var _this;

    _classCallCheck(this, ListItem);

    for (var _len = arguments.length, args = new Array(_len), _key = 0; _key < _len; _key++) {
      args[_key] = arguments[_key];
    }

    _this = _possibleConstructorReturn(this, (_getPrototypeOf2 = _getPrototypeOf(ListItem)).call.apply(_getPrototypeOf2, [this].concat(args)));
    _this.name = 'list_item';
    return _this;
  }

  _createClass(ListItem, [{
    key: "keys",
    value: function keys(_ref) {
      var type = _ref.type;
      return {
        Enter: splitListItem(type),
        Tab: sinkListItem(type),
        'Shift-Tab': liftListItem(type)
      };
    }
  }, {
    key: "schema",
    get: function get() {
      return {
        content: 'paragraph block*',
        defining: true,
        draggable: false,
        parseDOM: [{
          tag: 'li'
        }],
        toDOM: function toDOM() {
          return ['li', 0];
        }
      };
    }
  }]);

  return ListItem;
}(Node);

export { ListItem as default };
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uL2xpYi9ub2Rlcy9saXN0LWl0ZW0uanMiXSwibmFtZXMiOlsibGlmdExpc3RJdGVtIiwic2lua0xpc3RJdGVtIiwic3BsaXRMaXN0SXRlbSIsIk5vZGUiLCJQTU5vZGUiLCJMaXN0SXRlbSIsIm5hbWUiLCJ0eXBlIiwiRW50ZXIiLCJUYWIiLCJjb250ZW50IiwiZGVmaW5pbmciLCJkcmFnZ2FibGUiLCJwYXJzZURPTSIsInRhZyIsInRvRE9NIl0sIm1hcHBpbmdzIjoiOzs7Ozs7Ozs7Ozs7Ozs7O0FBRUEsU0FBU0EsWUFBVCxFQUF1QkMsWUFBdkIsRUFBcUNDLGFBQXJDLFFBQTBELHlCQUExRDtBQUVBLFNBQVNDLElBQVQsUUFBcUIsdUJBQXJCO0FBQ0EsU0FBU0EsSUFBSSxJQUFJQyxNQUFqQixRQUErQixtQkFBL0I7O0lBRXFCQyxROzs7Ozs7Ozs7Ozs7Ozs7OztVQUNuQkMsSSxHQUFPLFc7Ozs7OzsrQkFZZ0I7QUFBQSxVQUFoQkMsSUFBZ0IsUUFBaEJBLElBQWdCO0FBQ3JCLGFBQU87QUFDTEMsUUFBQUEsS0FBSyxFQUFFTixhQUFhLENBQUNLLElBQUQsQ0FEZjtBQUVMRSxRQUFBQSxHQUFHLEVBQUVSLFlBQVksQ0FBQ00sSUFBRCxDQUZaO0FBR0wscUJBQWFQLFlBQVksQ0FBQ08sSUFBRDtBQUhwQixPQUFQO0FBS0Q7Ozt3QkFoQlk7QUFDWCxhQUFPO0FBQ0xHLFFBQUFBLE9BQU8sRUFBRSxrQkFESjtBQUVMQyxRQUFBQSxRQUFRLEVBQUUsSUFGTDtBQUdMQyxRQUFBQSxTQUFTLEVBQUUsS0FITjtBQUlMQyxRQUFBQSxRQUFRLEVBQUUsQ0FBQztBQUFFQyxVQUFBQSxHQUFHLEVBQUU7QUFBUCxTQUFELENBSkw7QUFLTEMsUUFBQUEsS0FBSyxFQUFFO0FBQUEsaUJBQU0sQ0FBQyxJQUFELEVBQU8sQ0FBUCxDQUFOO0FBQUE7QUFMRixPQUFQO0FBT0Q7Ozs7RUFYbUNaLEk7O1NBQWpCRSxRIiwic291cmNlc0NvbnRlbnQiOlsiLy8gQGZsb3dcblxuaW1wb3J0IHsgbGlmdExpc3RJdGVtLCBzaW5rTGlzdEl0ZW0sIHNwbGl0TGlzdEl0ZW0gfSBmcm9tICdwcm9zZW1pcnJvci1zY2hlbWEtbGlzdCdcblxuaW1wb3J0IHsgTm9kZSB9IGZyb20gJ0BjaHVzcGFjZS9lZGl0b3ItYmFzZSdcbmltcG9ydCB7IE5vZGUgYXMgUE1Ob2RlIH0gZnJvbSAncHJvc2VtaXJyb3ItbW9kZWwnXG5cbmV4cG9ydCBkZWZhdWx0IGNsYXNzIExpc3RJdGVtIGV4dGVuZHMgTm9kZSB7XG4gIG5hbWUgPSAnbGlzdF9pdGVtJ1xuXG4gIGdldCBzY2hlbWEoKSB7XG4gICAgcmV0dXJuIHtcbiAgICAgIGNvbnRlbnQ6ICdwYXJhZ3JhcGggYmxvY2sqJyxcbiAgICAgIGRlZmluaW5nOiB0cnVlLFxuICAgICAgZHJhZ2dhYmxlOiBmYWxzZSxcbiAgICAgIHBhcnNlRE9NOiBbeyB0YWc6ICdsaScgfV0sXG4gICAgICB0b0RPTTogKCkgPT4gWydsaScsIDBdXG4gICAgfVxuICB9XG5cbiAga2V5cyh7IHR5cGUgfTogUE1Ob2RlKSB7XG4gICAgcmV0dXJuIHtcbiAgICAgIEVudGVyOiBzcGxpdExpc3RJdGVtKHR5cGUpLFxuICAgICAgVGFiOiBzaW5rTGlzdEl0ZW0odHlwZSksXG4gICAgICAnU2hpZnQtVGFiJzogbGlmdExpc3RJdGVtKHR5cGUpXG4gICAgfVxuICB9XG59XG4iXX0=