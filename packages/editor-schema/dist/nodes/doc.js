function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

function _possibleConstructorReturn(self, call) { if (call && (typeof call === "object" || typeof call === "function")) { return call; } return _assertThisInitialized(self); }

function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }

function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); if (superClass) _setPrototypeOf(subClass, superClass); }

function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf || function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }

import { Node } from '@chuspace/editor-base';

var Doc =
/*#__PURE__*/
function (_Node) {
  _inherits(Doc, _Node);

  function Doc() {
    var _getPrototypeOf2;

    var _this;

    _classCallCheck(this, Doc);

    for (var _len = arguments.length, args = new Array(_len), _key = 0; _key < _len; _key++) {
      args[_key] = arguments[_key];
    }

    _this = _possibleConstructorReturn(this, (_getPrototypeOf2 = _getPrototypeOf(Doc)).call.apply(_getPrototypeOf2, [this].concat(args)));
    _this.name = 'doc';
    return _this;
  }

  _createClass(Doc, [{
    key: "schema",
    get: function get() {
      return {
        content: 'block+'
      };
    }
  }]);

  return Doc;
}(Node);

export { Doc as default };
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uL2xpYi9ub2Rlcy9kb2MuanMiXSwibmFtZXMiOlsiTm9kZSIsIkRvYyIsIm5hbWUiLCJjb250ZW50Il0sIm1hcHBpbmdzIjoiOzs7Ozs7Ozs7Ozs7Ozs7O0FBRUEsU0FBU0EsSUFBVCxRQUFxQix1QkFBckI7O0lBRXFCQyxHOzs7Ozs7Ozs7Ozs7Ozs7OztVQUNuQkMsSSxHQUFPLEs7Ozs7Ozt3QkFFTTtBQUNYLGFBQU87QUFDTEMsUUFBQUEsT0FBTyxFQUFFO0FBREosT0FBUDtBQUdEOzs7O0VBUDhCSCxJOztTQUFaQyxHIiwic291cmNlc0NvbnRlbnQiOlsiLy8gQGZsb3dcblxuaW1wb3J0IHsgTm9kZSB9IGZyb20gJ0BjaHVzcGFjZS9lZGl0b3ItYmFzZSdcblxuZXhwb3J0IGRlZmF1bHQgY2xhc3MgRG9jIGV4dGVuZHMgTm9kZSB7XG4gIG5hbWUgPSAnZG9jJ1xuXG4gIGdldCBzY2hlbWEoKSB7XG4gICAgcmV0dXJuIHtcbiAgICAgIGNvbnRlbnQ6ICdibG9jaysnXG4gICAgfVxuICB9XG59XG4iXX0=