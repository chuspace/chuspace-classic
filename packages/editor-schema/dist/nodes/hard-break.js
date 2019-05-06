function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

function _possibleConstructorReturn(self, call) { if (call && (typeof call === "object" || typeof call === "function")) { return call; } return _assertThisInitialized(self); }

function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }

function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); if (superClass) _setPrototypeOf(subClass, superClass); }

function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf || function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }

import { chainCommands, exitCode } from 'prosemirror-commands';
import { Node } from '@chuspace/editor-base';
import { Node as PMNode } from 'prosemirror-model';

var HardBreak =
/*#__PURE__*/
function (_Node) {
  _inherits(HardBreak, _Node);

  function HardBreak() {
    var _getPrototypeOf2;

    var _this;

    _classCallCheck(this, HardBreak);

    for (var _len = arguments.length, args = new Array(_len), _key = 0; _key < _len; _key++) {
      args[_key] = arguments[_key];
    }

    _this = _possibleConstructorReturn(this, (_getPrototypeOf2 = _getPrototypeOf(HardBreak)).call.apply(_getPrototypeOf2, [this].concat(args)));
    _this.name = 'hard_break';
    return _this;
  }

  _createClass(HardBreak, [{
    key: "keys",
    value: function keys(_ref) {
      var type = _ref.type;
      var command = chainCommands(exitCode, function (state, dispatch) {
        dispatch(state.tr.replaceSelectionWith(type.create()).scrollIntoView());
        return true;
      });
      return {
        'Mod-Enter': command,
        'Shift-Enter': command
      };
    }
  }, {
    key: "schema",
    get: function get() {
      return {
        inline: true,
        group: 'inline',
        selectable: false,
        parseDOM: [{
          tag: 'br'
        }],
        toDOM: function toDOM() {
          return ['br'];
        }
      };
    }
  }]);

  return HardBreak;
}(Node);

export { HardBreak as default };
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uL2xpYi9ub2Rlcy9oYXJkLWJyZWFrLmpzIl0sIm5hbWVzIjpbImNoYWluQ29tbWFuZHMiLCJleGl0Q29kZSIsIk5vZGUiLCJQTU5vZGUiLCJIYXJkQnJlYWsiLCJuYW1lIiwidHlwZSIsImNvbW1hbmQiLCJzdGF0ZSIsImRpc3BhdGNoIiwidHIiLCJyZXBsYWNlU2VsZWN0aW9uV2l0aCIsImNyZWF0ZSIsInNjcm9sbEludG9WaWV3IiwiaW5saW5lIiwiZ3JvdXAiLCJzZWxlY3RhYmxlIiwicGFyc2VET00iLCJ0YWciLCJ0b0RPTSJdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7Ozs7Ozs7OztBQUVBLFNBQVNBLGFBQVQsRUFBd0JDLFFBQXhCLFFBQXdDLHNCQUF4QztBQUVBLFNBQVNDLElBQVQsUUFBcUIsdUJBQXJCO0FBQ0EsU0FBU0EsSUFBSSxJQUFJQyxNQUFqQixRQUErQixtQkFBL0I7O0lBRXFCQyxTOzs7Ozs7Ozs7Ozs7Ozs7OztVQUNuQkMsSSxHQUFPLFk7Ozs7OzsrQkFZZ0I7QUFBQSxVQUFoQkMsSUFBZ0IsUUFBaEJBLElBQWdCO0FBQ3JCLFVBQU1DLE9BQU8sR0FBR1AsYUFBYSxDQUFDQyxRQUFELEVBQVcsVUFBQ08sS0FBRCxFQUFRQyxRQUFSLEVBQXFCO0FBQzNEQSxRQUFBQSxRQUFRLENBQUNELEtBQUssQ0FBQ0UsRUFBTixDQUFTQyxvQkFBVCxDQUE4QkwsSUFBSSxDQUFDTSxNQUFMLEVBQTlCLEVBQTZDQyxjQUE3QyxFQUFELENBQVI7QUFDQSxlQUFPLElBQVA7QUFDRCxPQUg0QixDQUE3QjtBQUtBLGFBQU87QUFDTCxxQkFBYU4sT0FEUjtBQUVMLHVCQUFlQTtBQUZWLE9BQVA7QUFJRDs7O3dCQXBCWTtBQUNYLGFBQU87QUFDTE8sUUFBQUEsTUFBTSxFQUFFLElBREg7QUFFTEMsUUFBQUEsS0FBSyxFQUFFLFFBRkY7QUFHTEMsUUFBQUEsVUFBVSxFQUFFLEtBSFA7QUFJTEMsUUFBQUEsUUFBUSxFQUFFLENBQUM7QUFBRUMsVUFBQUEsR0FBRyxFQUFFO0FBQVAsU0FBRCxDQUpMO0FBS0xDLFFBQUFBLEtBQUssRUFBRTtBQUFBLGlCQUFNLENBQUMsSUFBRCxDQUFOO0FBQUE7QUFMRixPQUFQO0FBT0Q7Ozs7RUFYb0NqQixJOztTQUFsQkUsUyIsInNvdXJjZXNDb250ZW50IjpbIi8vIEBmbG93XG5cbmltcG9ydCB7IGNoYWluQ29tbWFuZHMsIGV4aXRDb2RlIH0gZnJvbSAncHJvc2VtaXJyb3ItY29tbWFuZHMnXG5cbmltcG9ydCB7IE5vZGUgfSBmcm9tICdAY2h1c3BhY2UvZWRpdG9yLWJhc2UnXG5pbXBvcnQgeyBOb2RlIGFzIFBNTm9kZSB9IGZyb20gJ3Byb3NlbWlycm9yLW1vZGVsJ1xuXG5leHBvcnQgZGVmYXVsdCBjbGFzcyBIYXJkQnJlYWsgZXh0ZW5kcyBOb2RlIHtcbiAgbmFtZSA9ICdoYXJkX2JyZWFrJ1xuXG4gIGdldCBzY2hlbWEoKSB7XG4gICAgcmV0dXJuIHtcbiAgICAgIGlubGluZTogdHJ1ZSxcbiAgICAgIGdyb3VwOiAnaW5saW5lJyxcbiAgICAgIHNlbGVjdGFibGU6IGZhbHNlLFxuICAgICAgcGFyc2VET006IFt7IHRhZzogJ2JyJyB9XSxcbiAgICAgIHRvRE9NOiAoKSA9PiBbJ2JyJ11cbiAgICB9XG4gIH1cblxuICBrZXlzKHsgdHlwZSB9OiBQTU5vZGUpIHtcbiAgICBjb25zdCBjb21tYW5kID0gY2hhaW5Db21tYW5kcyhleGl0Q29kZSwgKHN0YXRlLCBkaXNwYXRjaCkgPT4ge1xuICAgICAgZGlzcGF0Y2goc3RhdGUudHIucmVwbGFjZVNlbGVjdGlvbldpdGgodHlwZS5jcmVhdGUoKSkuc2Nyb2xsSW50b1ZpZXcoKSlcbiAgICAgIHJldHVybiB0cnVlXG4gICAgfSlcblxuICAgIHJldHVybiB7XG4gICAgICAnTW9kLUVudGVyJzogY29tbWFuZCxcbiAgICAgICdTaGlmdC1FbnRlcic6IGNvbW1hbmRcbiAgICB9XG4gIH1cbn1cbiJdfQ==