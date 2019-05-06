function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

function _possibleConstructorReturn(self, call) { if (call && (typeof call === "object" || typeof call === "function")) { return call; } return _assertThisInitialized(self); }

function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }

function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); if (superClass) _setPrototypeOf(subClass, superClass); }

function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf || function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }

import { history, redo as _redo, undo as _undo } from 'prosemirror-history';
import { Element } from '@chuspace/editor-base';

var History =
/*#__PURE__*/
function (_Element) {
  _inherits(History, _Element);

  function History() {
    var _getPrototypeOf2;

    var _this;

    _classCallCheck(this, History);

    for (var _len = arguments.length, args = new Array(_len), _key = 0; _key < _len; _key++) {
      args[_key] = arguments[_key];
    }

    _this = _possibleConstructorReturn(this, (_getPrototypeOf2 = _getPrototypeOf(History)).call.apply(_getPrototypeOf2, [this].concat(args)));
    _this.name = 'history';
    _this.options = {
      depth: '',
      newGroupDelay: ''
    };
    return _this;
  }

  _createClass(History, [{
    key: "keys",
    value: function keys() {
      var isMac = typeof navigator !== 'undefined' ? /Mac/.test(navigator.platform) : false;
      var keymap = {
        'Mod-z': _undo,
        'Shift-Mod-z': _redo
      };

      if (!isMac) {
        keymap['Mod-y'] = _redo;
      }

      return keymap;
    }
  }, {
    key: "commands",
    value: function commands() {
      return {
        undo: function undo() {
          return _undo;
        },
        redo: function redo() {
          return _redo;
        }
      };
    }
  }, {
    key: "plugins",
    get: function get() {
      return [history({
        depth: this.options.depth,
        newGroupDelay: this.options.newGroupDelay
      })];
    }
  }]);

  return History;
}(Element);

export { History as default };
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uL2xpYi9oaXN0b3J5LmpzIl0sIm5hbWVzIjpbImhpc3RvcnkiLCJyZWRvIiwidW5kbyIsIkVsZW1lbnQiLCJIaXN0b3J5IiwibmFtZSIsIm9wdGlvbnMiLCJkZXB0aCIsIm5ld0dyb3VwRGVsYXkiLCJpc01hYyIsIm5hdmlnYXRvciIsInRlc3QiLCJwbGF0Zm9ybSIsImtleW1hcCJdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7Ozs7Ozs7OztBQUVBLFNBQVNBLE9BQVQsRUFBa0JDLElBQUksSUFBSkEsS0FBbEIsRUFBd0JDLElBQUksSUFBSkEsS0FBeEIsUUFBb0MscUJBQXBDO0FBRUEsU0FBU0MsT0FBVCxRQUF3Qix1QkFBeEI7O0lBRXFCQyxPOzs7Ozs7Ozs7Ozs7Ozs7OztVQUNuQkMsSSxHQUFPLFM7VUFFUEMsTyxHQUFVO0FBQ1JDLE1BQUFBLEtBQUssRUFBRSxFQURDO0FBRVJDLE1BQUFBLGFBQWEsRUFBRTtBQUZQLEs7Ozs7OzsyQkFLSDtBQUNMLFVBQU1DLEtBQUssR0FBRyxPQUFPQyxTQUFQLEtBQXFCLFdBQXJCLEdBQW1DLE1BQU1DLElBQU4sQ0FBV0QsU0FBUyxDQUFDRSxRQUFyQixDQUFuQyxHQUFvRSxLQUFsRjtBQUNBLFVBQU1DLE1BQU0sR0FBRztBQUNiLGlCQUFTWCxLQURJO0FBRWIsdUJBQWVEO0FBRkYsT0FBZjs7QUFLQSxVQUFJLENBQUNRLEtBQUwsRUFBWTtBQUNWSSxRQUFBQSxNQUFNLENBQUMsT0FBRCxDQUFOLEdBQWtCWixLQUFsQjtBQUNEOztBQUVELGFBQU9ZLE1BQVA7QUFDRDs7OytCQVdVO0FBQ1QsYUFBTztBQUNMWCxRQUFBQSxJQUFJLEVBQUU7QUFBQSxpQkFBTUEsS0FBTjtBQUFBLFNBREQ7QUFFTEQsUUFBQUEsSUFBSSxFQUFFO0FBQUEsaUJBQU1BLEtBQU47QUFBQTtBQUZELE9BQVA7QUFJRDs7O3dCQWRhO0FBQ1osYUFBTyxDQUNMRCxPQUFPLENBQUM7QUFDTk8sUUFBQUEsS0FBSyxFQUFFLEtBQUtELE9BQUwsQ0FBYUMsS0FEZDtBQUVOQyxRQUFBQSxhQUFhLEVBQUUsS0FBS0YsT0FBTCxDQUFhRTtBQUZ0QixPQUFELENBREYsQ0FBUDtBQU1EOzs7O0VBN0JrQ0wsTzs7U0FBaEJDLE8iLCJzb3VyY2VzQ29udGVudCI6WyIvLyBAZmxvd1xuXG5pbXBvcnQgeyBoaXN0b3J5LCByZWRvLCB1bmRvIH0gZnJvbSAncHJvc2VtaXJyb3ItaGlzdG9yeSdcblxuaW1wb3J0IHsgRWxlbWVudCB9IGZyb20gJ0BjaHVzcGFjZS9lZGl0b3ItYmFzZSdcblxuZXhwb3J0IGRlZmF1bHQgY2xhc3MgSGlzdG9yeSBleHRlbmRzIEVsZW1lbnQge1xuICBuYW1lID0gJ2hpc3RvcnknXG5cbiAgb3B0aW9ucyA9IHtcbiAgICBkZXB0aDogJycsXG4gICAgbmV3R3JvdXBEZWxheTogJydcbiAgfVxuXG4gIGtleXMoKSB7XG4gICAgY29uc3QgaXNNYWMgPSB0eXBlb2YgbmF2aWdhdG9yICE9PSAndW5kZWZpbmVkJyA/IC9NYWMvLnRlc3QobmF2aWdhdG9yLnBsYXRmb3JtKSA6IGZhbHNlXG4gICAgY29uc3Qga2V5bWFwID0ge1xuICAgICAgJ01vZC16JzogdW5kbyxcbiAgICAgICdTaGlmdC1Nb2Qteic6IHJlZG9cbiAgICB9XG5cbiAgICBpZiAoIWlzTWFjKSB7XG4gICAgICBrZXltYXBbJ01vZC15J10gPSByZWRvXG4gICAgfVxuXG4gICAgcmV0dXJuIGtleW1hcFxuICB9XG5cbiAgZ2V0IHBsdWdpbnMoKSB7XG4gICAgcmV0dXJuIFtcbiAgICAgIGhpc3Rvcnkoe1xuICAgICAgICBkZXB0aDogdGhpcy5vcHRpb25zLmRlcHRoLFxuICAgICAgICBuZXdHcm91cERlbGF5OiB0aGlzLm9wdGlvbnMubmV3R3JvdXBEZWxheVxuICAgICAgfSlcbiAgICBdXG4gIH1cblxuICBjb21tYW5kcygpIHtcbiAgICByZXR1cm4ge1xuICAgICAgdW5kbzogKCkgPT4gdW5kbyxcbiAgICAgIHJlZG86ICgpID0+IHJlZG9cbiAgICB9XG4gIH1cbn1cbiJdfQ==