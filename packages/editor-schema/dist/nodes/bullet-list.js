function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

function _possibleConstructorReturn(self, call) { if (call && (typeof call === "object" || typeof call === "function")) { return call; } return _assertThisInitialized(self); }

function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }

function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); if (superClass) _setPrototypeOf(subClass, superClass); }

function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf || function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }

import { Node } from '@chuspace/editor-base';
import { Node as PMNode } from 'prosemirror-model';
import { toggleList } from '@chuspace/editor-commands';
import { wrappingInputRule } from 'prosemirror-inputrules';

var BulletList =
/*#__PURE__*/
function (_Node) {
  _inherits(BulletList, _Node);

  function BulletList() {
    var _getPrototypeOf2;

    var _this;

    _classCallCheck(this, BulletList);

    for (var _len = arguments.length, args = new Array(_len), _key = 0; _key < _len; _key++) {
      args[_key] = arguments[_key];
    }

    _this = _possibleConstructorReturn(this, (_getPrototypeOf2 = _getPrototypeOf(BulletList)).call.apply(_getPrototypeOf2, [this].concat(args)));
    _this.name = 'bullet_list';
    return _this;
  }

  _createClass(BulletList, [{
    key: "commands",
    value: function commands(_ref) {
      var type = _ref.type,
          schema = _ref.schema;
      return function () {
        return toggleList(type, schema.nodes.list_item);
      };
    }
  }, {
    key: "keys",
    value: function keys(_ref2) {
      var type = _ref2.type,
          schema = _ref2.schema;
      return {
        'Shift-Ctrl-8': toggleList(type, schema.nodes.list_item)
      };
    }
  }, {
    key: "inputRules",
    value: function inputRules(_ref3) {
      var type = _ref3.type;
      return [wrappingInputRule(/^\s*([-+*])\s$/, type)];
    }
  }, {
    key: "schema",
    get: function get() {
      return {
        content: 'list_item+',
        group: 'block',
        parseDOM: [{
          tag: 'ul'
        }],
        toDOM: function toDOM() {
          return ['ul', 0];
        }
      };
    }
  }]);

  return BulletList;
}(Node);

export { BulletList as default };
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uL2xpYi9ub2Rlcy9idWxsZXQtbGlzdC5qcyJdLCJuYW1lcyI6WyJOb2RlIiwiUE1Ob2RlIiwidG9nZ2xlTGlzdCIsIndyYXBwaW5nSW5wdXRSdWxlIiwiQnVsbGV0TGlzdCIsIm5hbWUiLCJ0eXBlIiwic2NoZW1hIiwibm9kZXMiLCJsaXN0X2l0ZW0iLCJjb250ZW50IiwiZ3JvdXAiLCJwYXJzZURPTSIsInRhZyIsInRvRE9NIl0sIm1hcHBpbmdzIjoiOzs7Ozs7Ozs7Ozs7Ozs7O0FBRUEsU0FBU0EsSUFBVCxRQUFxQix1QkFBckI7QUFDQSxTQUFTQSxJQUFJLElBQUlDLE1BQWpCLFFBQStCLG1CQUEvQjtBQUNBLFNBQVNDLFVBQVQsUUFBMkIsMkJBQTNCO0FBQ0EsU0FBU0MsaUJBQVQsUUFBa0Msd0JBQWxDOztJQUVxQkMsVTs7Ozs7Ozs7Ozs7Ozs7Ozs7VUFDbkJDLEksR0FBTyxhOzs7Ozs7bUNBVzRCO0FBQUEsVUFBeEJDLElBQXdCLFFBQXhCQSxJQUF3QjtBQUFBLFVBQWxCQyxNQUFrQixRQUFsQkEsTUFBa0I7QUFDakMsYUFBTztBQUFBLGVBQU1MLFVBQVUsQ0FBQ0ksSUFBRCxFQUFPQyxNQUFNLENBQUNDLEtBQVAsQ0FBYUMsU0FBcEIsQ0FBaEI7QUFBQSxPQUFQO0FBQ0Q7OztnQ0FFOEI7QUFBQSxVQUF4QkgsSUFBd0IsU0FBeEJBLElBQXdCO0FBQUEsVUFBbEJDLE1BQWtCLFNBQWxCQSxNQUFrQjtBQUM3QixhQUFPO0FBQ0wsd0JBQWdCTCxVQUFVLENBQUNJLElBQUQsRUFBT0MsTUFBTSxDQUFDQyxLQUFQLENBQWFDLFNBQXBCO0FBRHJCLE9BQVA7QUFHRDs7O3NDQUU0QjtBQUFBLFVBQWhCSCxJQUFnQixTQUFoQkEsSUFBZ0I7QUFDM0IsYUFBTyxDQUFDSCxpQkFBaUIsQ0FBQyxnQkFBRCxFQUFtQkcsSUFBbkIsQ0FBbEIsQ0FBUDtBQUNEOzs7d0JBckJZO0FBQ1gsYUFBTztBQUNMSSxRQUFBQSxPQUFPLEVBQUUsWUFESjtBQUVMQyxRQUFBQSxLQUFLLEVBQUUsT0FGRjtBQUdMQyxRQUFBQSxRQUFRLEVBQUUsQ0FBQztBQUFFQyxVQUFBQSxHQUFHLEVBQUU7QUFBUCxTQUFELENBSEw7QUFJTEMsUUFBQUEsS0FBSyxFQUFFO0FBQUEsaUJBQU0sQ0FBQyxJQUFELEVBQU8sQ0FBUCxDQUFOO0FBQUE7QUFKRixPQUFQO0FBTUQ7Ozs7RUFWcUNkLEk7O1NBQW5CSSxVIiwic291cmNlc0NvbnRlbnQiOlsiLy8gQGZsb3dcblxuaW1wb3J0IHsgTm9kZSB9IGZyb20gJ0BjaHVzcGFjZS9lZGl0b3ItYmFzZSdcbmltcG9ydCB7IE5vZGUgYXMgUE1Ob2RlIH0gZnJvbSAncHJvc2VtaXJyb3ItbW9kZWwnXG5pbXBvcnQgeyB0b2dnbGVMaXN0IH0gZnJvbSAnQGNodXNwYWNlL2VkaXRvci1jb21tYW5kcydcbmltcG9ydCB7IHdyYXBwaW5nSW5wdXRSdWxlIH0gZnJvbSAncHJvc2VtaXJyb3ItaW5wdXRydWxlcydcblxuZXhwb3J0IGRlZmF1bHQgY2xhc3MgQnVsbGV0TGlzdCBleHRlbmRzIE5vZGUge1xuICBuYW1lID0gJ2J1bGxldF9saXN0J1xuXG4gIGdldCBzY2hlbWEoKSB7XG4gICAgcmV0dXJuIHtcbiAgICAgIGNvbnRlbnQ6ICdsaXN0X2l0ZW0rJyxcbiAgICAgIGdyb3VwOiAnYmxvY2snLFxuICAgICAgcGFyc2VET006IFt7IHRhZzogJ3VsJyB9XSxcbiAgICAgIHRvRE9NOiAoKSA9PiBbJ3VsJywgMF1cbiAgICB9XG4gIH1cblxuICBjb21tYW5kcyh7IHR5cGUsIHNjaGVtYSB9OiBQTU5vZGUpIHtcbiAgICByZXR1cm4gKCkgPT4gdG9nZ2xlTGlzdCh0eXBlLCBzY2hlbWEubm9kZXMubGlzdF9pdGVtKVxuICB9XG5cbiAga2V5cyh7IHR5cGUsIHNjaGVtYSB9OiBQTU5vZGUpIHtcbiAgICByZXR1cm4ge1xuICAgICAgJ1NoaWZ0LUN0cmwtOCc6IHRvZ2dsZUxpc3QodHlwZSwgc2NoZW1hLm5vZGVzLmxpc3RfaXRlbSlcbiAgICB9XG4gIH1cblxuICBpbnB1dFJ1bGVzKHsgdHlwZSB9OiBQTU5vZGUpIHtcbiAgICByZXR1cm4gW3dyYXBwaW5nSW5wdXRSdWxlKC9eXFxzKihbLSsqXSlcXHMkLywgdHlwZSldXG4gIH1cbn1cbiJdfQ==