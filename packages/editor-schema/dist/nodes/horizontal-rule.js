function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

function _possibleConstructorReturn(self, call) { if (call && (typeof call === "object" || typeof call === "function")) { return call; } return _assertThisInitialized(self); }

function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }

function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); if (superClass) _setPrototypeOf(subClass, superClass); }

function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf || function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }

import { EditorState, Transaction } from 'prosemirror-state';
import { Node } from '@chuspace/editor-base';
import { Node as PMNode } from 'prosemirror-model';
import { nodeInputRule } from '@chuspace/editor-commands';

var HorizontalRule =
/*#__PURE__*/
function (_Node) {
  _inherits(HorizontalRule, _Node);

  function HorizontalRule() {
    var _getPrototypeOf2;

    var _this;

    _classCallCheck(this, HorizontalRule);

    for (var _len = arguments.length, args = new Array(_len), _key = 0; _key < _len; _key++) {
      args[_key] = arguments[_key];
    }

    _this = _possibleConstructorReturn(this, (_getPrototypeOf2 = _getPrototypeOf(HorizontalRule)).call.apply(_getPrototypeOf2, [this].concat(args)));
    _this.name = 'horizontal_rule';
    return _this;
  }

  _createClass(HorizontalRule, [{
    key: "commands",
    value: function commands(_ref) {
      var type = _ref.type;
      return function () {
        return function (state, dispatch) {
          return dispatch(state.tr.replaceSelectionWith(type.create()));
        };
      };
    }
  }, {
    key: "inputRules",
    value: function inputRules(_ref2) {
      var type = _ref2.type;
      return [nodeInputRule(/^(?:---|___\s|\*\*\*\s)$/, type)];
    }
  }, {
    key: "schema",
    get: function get() {
      return {
        group: 'block',
        parseDOM: [{
          tag: 'hr'
        }],
        toDOM: function toDOM() {
          return ['hr'];
        }
      };
    }
  }]);

  return HorizontalRule;
}(Node);

export { HorizontalRule as default };
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uL2xpYi9ub2Rlcy9ob3Jpem9udGFsLXJ1bGUuanMiXSwibmFtZXMiOlsiRWRpdG9yU3RhdGUiLCJUcmFuc2FjdGlvbiIsIk5vZGUiLCJQTU5vZGUiLCJub2RlSW5wdXRSdWxlIiwiSG9yaXpvbnRhbFJ1bGUiLCJuYW1lIiwidHlwZSIsInN0YXRlIiwiZGlzcGF0Y2giLCJ0ciIsInJlcGxhY2VTZWxlY3Rpb25XaXRoIiwiY3JlYXRlIiwiZ3JvdXAiLCJwYXJzZURPTSIsInRhZyIsInRvRE9NIl0sIm1hcHBpbmdzIjoiOzs7Ozs7Ozs7Ozs7Ozs7O0FBRUEsU0FBU0EsV0FBVCxFQUFzQkMsV0FBdEIsUUFBeUMsbUJBQXpDO0FBRUEsU0FBU0MsSUFBVCxRQUFxQix1QkFBckI7QUFDQSxTQUFTQSxJQUFJLElBQUlDLE1BQWpCLFFBQStCLG1CQUEvQjtBQUNBLFNBQVNDLGFBQVQsUUFBOEIsMkJBQTlCOztJQUVxQkMsYzs7Ozs7Ozs7Ozs7Ozs7Ozs7VUFDbkJDLEksR0FBTyxpQjs7Ozs7O21DQVVvQjtBQUFBLFVBQWhCQyxJQUFnQixRQUFoQkEsSUFBZ0I7QUFDekIsYUFBTztBQUFBLGVBQU0sVUFBQ0MsS0FBRCxFQUFxQkMsUUFBckI7QUFBQSxpQkFBK0NBLFFBQVEsQ0FBQ0QsS0FBSyxDQUFDRSxFQUFOLENBQVNDLG9CQUFULENBQThCSixJQUFJLENBQUNLLE1BQUwsRUFBOUIsQ0FBRCxDQUF2RDtBQUFBLFNBQU47QUFBQSxPQUFQO0FBQ0Q7OztzQ0FFNEI7QUFBQSxVQUFoQkwsSUFBZ0IsU0FBaEJBLElBQWdCO0FBQzNCLGFBQU8sQ0FBQ0gsYUFBYSxDQUFDLDBCQUFELEVBQTZCRyxJQUE3QixDQUFkLENBQVA7QUFDRDs7O3dCQWRZO0FBQ1gsYUFBTztBQUNMTSxRQUFBQSxLQUFLLEVBQUUsT0FERjtBQUVMQyxRQUFBQSxRQUFRLEVBQUUsQ0FBQztBQUFFQyxVQUFBQSxHQUFHLEVBQUU7QUFBUCxTQUFELENBRkw7QUFHTEMsUUFBQUEsS0FBSyxFQUFFO0FBQUEsaUJBQU0sQ0FBQyxJQUFELENBQU47QUFBQTtBQUhGLE9BQVA7QUFLRDs7OztFQVR5Q2QsSTs7U0FBdkJHLGMiLCJzb3VyY2VzQ29udGVudCI6WyIvLyBAZmxvd1xuXG5pbXBvcnQgeyBFZGl0b3JTdGF0ZSwgVHJhbnNhY3Rpb24gfSBmcm9tICdwcm9zZW1pcnJvci1zdGF0ZSdcblxuaW1wb3J0IHsgTm9kZSB9IGZyb20gJ0BjaHVzcGFjZS9lZGl0b3ItYmFzZSdcbmltcG9ydCB7IE5vZGUgYXMgUE1Ob2RlIH0gZnJvbSAncHJvc2VtaXJyb3ItbW9kZWwnXG5pbXBvcnQgeyBub2RlSW5wdXRSdWxlIH0gZnJvbSAnQGNodXNwYWNlL2VkaXRvci1jb21tYW5kcydcblxuZXhwb3J0IGRlZmF1bHQgY2xhc3MgSG9yaXpvbnRhbFJ1bGUgZXh0ZW5kcyBOb2RlIHtcbiAgbmFtZSA9ICdob3Jpem9udGFsX3J1bGUnXG5cbiAgZ2V0IHNjaGVtYSgpIHtcbiAgICByZXR1cm4ge1xuICAgICAgZ3JvdXA6ICdibG9jaycsXG4gICAgICBwYXJzZURPTTogW3sgdGFnOiAnaHInIH1dLFxuICAgICAgdG9ET006ICgpID0+IFsnaHInXVxuICAgIH1cbiAgfVxuXG4gIGNvbW1hbmRzKHsgdHlwZSB9OiBQTU5vZGUpIHtcbiAgICByZXR1cm4gKCkgPT4gKHN0YXRlOiBFZGl0b3JTdGF0ZSwgZGlzcGF0Y2g6IFRyYW5zYWN0aW9uKSA9PiBkaXNwYXRjaChzdGF0ZS50ci5yZXBsYWNlU2VsZWN0aW9uV2l0aCh0eXBlLmNyZWF0ZSgpKSlcbiAgfVxuXG4gIGlucHV0UnVsZXMoeyB0eXBlIH06IFBNTm9kZSkge1xuICAgIHJldHVybiBbbm9kZUlucHV0UnVsZSgvXig/Oi0tLXxfX19cXHN8XFwqXFwqXFwqXFxzKSQvLCB0eXBlKV1cbiAgfVxufVxuIl19