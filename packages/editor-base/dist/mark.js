function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

function _possibleConstructorReturn(self, call) { if (call && (typeof call === "object" || typeof call === "function")) { return call; } return _assertThisInitialized(self); }

function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }

function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); if (superClass) _setPrototypeOf(subClass, superClass); }

function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf || function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }

import Element from './element';

var Mark =
/*#__PURE__*/
function (_Element) {
  _inherits(Mark, _Element);

  function Mark() {
    var options = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {};

    _classCallCheck(this, Mark);

    return _possibleConstructorReturn(this, _getPrototypeOf(Mark).call(this, options));
  }

  _createClass(Mark, [{
    key: "command",
    value: function command() {
      return function () {};
    }
  }, {
    key: "type",
    get: function get() {
      return 'mark';
    }
  }, {
    key: "view",
    get: function get() {
      return {};
    }
  }, {
    key: "schema",
    get: function get() {
      return {};
    }
  }]);

  return Mark;
}(Element);

export { Mark as default };
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uL2xpYi9tYXJrLmpzIl0sIm5hbWVzIjpbIkVsZW1lbnQiLCJNYXJrIiwib3B0aW9ucyJdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7Ozs7Ozs7OztBQUVBLE9BQU9BLE9BQVAsTUFBb0IsV0FBcEI7O0lBRXFCQyxJOzs7OztBQUNuQixrQkFBOEI7QUFBQSxRQUFsQkMsT0FBa0IsdUVBQUosRUFBSTs7QUFBQTs7QUFBQSw2RUFDdEJBLE9BRHNCO0FBRTdCOzs7OzhCQWNTO0FBQ1IsYUFBTyxZQUFNLENBQUUsQ0FBZjtBQUNEOzs7d0JBZFU7QUFDVCxhQUFPLE1BQVA7QUFDRDs7O3dCQUVVO0FBQ1QsYUFBTyxFQUFQO0FBQ0Q7Ozt3QkFFWTtBQUNYLGFBQU8sRUFBUDtBQUNEOzs7O0VBZitCRixPOztTQUFiQyxJIiwic291cmNlc0NvbnRlbnQiOlsiLy8gQGZsb3dcblxuaW1wb3J0IEVsZW1lbnQgZnJvbSAnLi9lbGVtZW50J1xuXG5leHBvcnQgZGVmYXVsdCBjbGFzcyBNYXJrIGV4dGVuZHMgRWxlbWVudCB7XG4gIGNvbnN0cnVjdG9yKG9wdGlvbnM6IHt9ID0ge30pIHtcbiAgICBzdXBlcihvcHRpb25zKVxuICB9XG5cbiAgZ2V0IHR5cGUoKSB7XG4gICAgcmV0dXJuICdtYXJrJ1xuICB9XG5cbiAgZ2V0IHZpZXcoKSB7XG4gICAgcmV0dXJuIHt9XG4gIH1cblxuICBnZXQgc2NoZW1hKCkge1xuICAgIHJldHVybiB7fVxuICB9XG5cbiAgY29tbWFuZCgpIHtcbiAgICByZXR1cm4gKCkgPT4ge31cbiAgfVxufVxuIl19