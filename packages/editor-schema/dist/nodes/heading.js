function _objectSpread(target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i] != null ? arguments[i] : {}; var ownKeys = Object.keys(source); if (typeof Object.getOwnPropertySymbols === 'function') { ownKeys = ownKeys.concat(Object.getOwnPropertySymbols(source).filter(function (sym) { return Object.getOwnPropertyDescriptor(source, sym).enumerable; })); } ownKeys.forEach(function (key) { _defineProperty(target, key, source[key]); }); } return target; }

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

function _possibleConstructorReturn(self, call) { if (call && (typeof call === "object" || typeof call === "function")) { return call; } return _assertThisInitialized(self); }

function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }

function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); if (superClass) _setPrototypeOf(subClass, superClass); }

function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf || function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }

import { setBlockType, toggleBlockType } from '@chuspace/editor-commands';
import { Node } from '@chuspace/editor-base';
import { Node as PMNode } from 'prosemirror-model';
import { textblockTypeInputRule } from 'prosemirror-inputrules';

var Heading =
/*#__PURE__*/
function (_Node) {
  _inherits(Heading, _Node);

  function Heading() {
    var _getPrototypeOf2;

    var _this;

    _classCallCheck(this, Heading);

    for (var _len = arguments.length, args = new Array(_len), _key = 0; _key < _len; _key++) {
      args[_key] = arguments[_key];
    }

    _this = _possibleConstructorReturn(this, (_getPrototypeOf2 = _getPrototypeOf(Heading)).call.apply(_getPrototypeOf2, [this].concat(args)));
    _this.name = 'heading';
    _this.options = {
      levels: [1, 2, 3, 4, 5, 6]
    };
    return _this;
  }

  _createClass(Heading, [{
    key: "commands",
    value: function commands(_ref) {
      var type = _ref.type,
          schema = _ref.schema;
      return function (attrs) {
        return toggleBlockType(type, schema.nodes.paragraph, attrs);
      };
    }
  }, {
    key: "keys",
    value: function keys(_ref2) {
      var type = _ref2.type;
      return this.options.levels.reduce(function (items, level) {
        return _objectSpread({}, items, _defineProperty({}, "Shift-Ctrl-".concat(level), setBlockType(type, {
          level: level
        })));
      }, {});
    }
  }, {
    key: "inputRules",
    value: function inputRules(_ref3) {
      var type = _ref3.type;
      return this.options.levels.map(function (level) {
        return textblockTypeInputRule(new RegExp("^(#{1,".concat(level, "})\\s$")), type, function () {
          return {
            level: level
          };
        });
      });
    }
  }, {
    key: "schema",
    get: function get() {
      return {
        attrs: {
          level: {
            "default": 1
          }
        },
        content: 'inline*',
        group: 'block',
        defining: true,
        draggable: false,
        parseDOM: this.options.levels.map(function (level) {
          return {
            tag: "h".concat(level),
            attrs: {
              level: level
            }
          };
        }),
        toDOM: function toDOM(node) {
          return ["h".concat(node.attrs.level), 0];
        }
      };
    }
  }]);

  return Heading;
}(Node);

export { Heading as default };
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uL2xpYi9ub2Rlcy9oZWFkaW5nLmpzIl0sIm5hbWVzIjpbInNldEJsb2NrVHlwZSIsInRvZ2dsZUJsb2NrVHlwZSIsIk5vZGUiLCJQTU5vZGUiLCJ0ZXh0YmxvY2tUeXBlSW5wdXRSdWxlIiwiSGVhZGluZyIsIm5hbWUiLCJvcHRpb25zIiwibGV2ZWxzIiwidHlwZSIsInNjaGVtYSIsImF0dHJzIiwibm9kZXMiLCJwYXJhZ3JhcGgiLCJyZWR1Y2UiLCJpdGVtcyIsImxldmVsIiwibWFwIiwiUmVnRXhwIiwiY29udGVudCIsImdyb3VwIiwiZGVmaW5pbmciLCJkcmFnZ2FibGUiLCJwYXJzZURPTSIsInRhZyIsInRvRE9NIiwibm9kZSJdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7QUFFQSxTQUFTQSxZQUFULEVBQXVCQyxlQUF2QixRQUE4QywyQkFBOUM7QUFFQSxTQUFTQyxJQUFULFFBQXFCLHVCQUFyQjtBQUNBLFNBQVNBLElBQUksSUFBSUMsTUFBakIsUUFBK0IsbUJBQS9CO0FBQ0EsU0FBU0Msc0JBQVQsUUFBdUMsd0JBQXZDOztJQU1xQkMsTzs7Ozs7Ozs7Ozs7Ozs7Ozs7VUFDbkJDLEksR0FBTyxTO1VBRVBDLE8sR0FBbUI7QUFDakJDLE1BQUFBLE1BQU0sRUFBRSxDQUFDLENBQUQsRUFBSSxDQUFKLEVBQU8sQ0FBUCxFQUFVLENBQVYsRUFBYSxDQUFiLEVBQWdCLENBQWhCO0FBRFMsSzs7Ozs7O21DQXVCZ0I7QUFBQSxVQUF4QkMsSUFBd0IsUUFBeEJBLElBQXdCO0FBQUEsVUFBbEJDLE1BQWtCLFFBQWxCQSxNQUFrQjtBQUNqQyxhQUFPLFVBQUNDLEtBQUQ7QUFBQSxlQUFlVixlQUFlLENBQUNRLElBQUQsRUFBT0MsTUFBTSxDQUFDRSxLQUFQLENBQWFDLFNBQXBCLEVBQStCRixLQUEvQixDQUE5QjtBQUFBLE9BQVA7QUFDRDs7O2dDQUVzQjtBQUFBLFVBQWhCRixJQUFnQixTQUFoQkEsSUFBZ0I7QUFDckIsYUFBTyxLQUFLRixPQUFMLENBQWFDLE1BQWIsQ0FBb0JNLE1BQXBCLENBQ0wsVUFBQ0MsS0FBRCxFQUFRQyxLQUFSO0FBQUEsaUNBQ0tELEtBREwsMkNBR21CQyxLQUhuQixHQUc2QmhCLFlBQVksQ0FBQ1MsSUFBRCxFQUFPO0FBQUVPLFVBQUFBLEtBQUssRUFBTEE7QUFBRixTQUFQLENBSHpDO0FBQUEsT0FESyxFQU9MLEVBUEssQ0FBUDtBQVNEOzs7c0NBRTRCO0FBQUEsVUFBaEJQLElBQWdCLFNBQWhCQSxJQUFnQjtBQUMzQixhQUFPLEtBQUtGLE9BQUwsQ0FBYUMsTUFBYixDQUFvQlMsR0FBcEIsQ0FBd0IsVUFBQUQsS0FBSztBQUFBLGVBQ2xDWixzQkFBc0IsQ0FBQyxJQUFJYyxNQUFKLGlCQUFvQkYsS0FBcEIsWUFBRCxFQUFxQ1AsSUFBckMsRUFBMkM7QUFBQSxpQkFBTztBQUN0RU8sWUFBQUEsS0FBSyxFQUFMQTtBQURzRSxXQUFQO0FBQUEsU0FBM0MsQ0FEWTtBQUFBLE9BQTdCLENBQVA7QUFLRDs7O3dCQXpDWTtBQUNYLGFBQU87QUFDTEwsUUFBQUEsS0FBSyxFQUFFO0FBQ0xLLFVBQUFBLEtBQUssRUFBRTtBQUNMLHVCQUFTO0FBREo7QUFERixTQURGO0FBTUxHLFFBQUFBLE9BQU8sRUFBRSxTQU5KO0FBT0xDLFFBQUFBLEtBQUssRUFBRSxPQVBGO0FBUUxDLFFBQUFBLFFBQVEsRUFBRSxJQVJMO0FBU0xDLFFBQUFBLFNBQVMsRUFBRSxLQVROO0FBVUxDLFFBQUFBLFFBQVEsRUFBRSxLQUFLaEIsT0FBTCxDQUFhQyxNQUFiLENBQW9CUyxHQUFwQixDQUF3QixVQUFDRCxLQUFEO0FBQUEsaUJBQW9CO0FBQ3BEUSxZQUFBQSxHQUFHLGFBQU1SLEtBQU4sQ0FEaUQ7QUFFcERMLFlBQUFBLEtBQUssRUFBRTtBQUFFSyxjQUFBQSxLQUFLLEVBQUxBO0FBQUY7QUFGNkMsV0FBcEI7QUFBQSxTQUF4QixDQVZMO0FBY0xTLFFBQUFBLEtBQUssRUFBRSxlQUFDQyxJQUFEO0FBQUEsaUJBQWtCLFlBQUtBLElBQUksQ0FBQ2YsS0FBTCxDQUFXSyxLQUFoQixHQUF5QixDQUF6QixDQUFsQjtBQUFBO0FBZEYsT0FBUDtBQWdCRDs7OztFQXhCa0NkLEk7O1NBQWhCRyxPIiwic291cmNlc0NvbnRlbnQiOlsiLy8gQGZsb3dcblxuaW1wb3J0IHsgc2V0QmxvY2tUeXBlLCB0b2dnbGVCbG9ja1R5cGUgfSBmcm9tICdAY2h1c3BhY2UvZWRpdG9yLWNvbW1hbmRzJ1xuXG5pbXBvcnQgeyBOb2RlIH0gZnJvbSAnQGNodXNwYWNlL2VkaXRvci1iYXNlJ1xuaW1wb3J0IHsgTm9kZSBhcyBQTU5vZGUgfSBmcm9tICdwcm9zZW1pcnJvci1tb2RlbCdcbmltcG9ydCB7IHRleHRibG9ja1R5cGVJbnB1dFJ1bGUgfSBmcm9tICdwcm9zZW1pcnJvci1pbnB1dHJ1bGVzJ1xuXG50eXBlIE9wdGlvbnMgPSB7XG4gIGxldmVsczogQXJyYXk8bnVtYmVyPlxufVxuXG5leHBvcnQgZGVmYXVsdCBjbGFzcyBIZWFkaW5nIGV4dGVuZHMgTm9kZSB7XG4gIG5hbWUgPSAnaGVhZGluZydcblxuICBvcHRpb25zOiBPcHRpb25zID0ge1xuICAgIGxldmVsczogWzEsIDIsIDMsIDQsIDUsIDZdXG4gIH1cblxuICBnZXQgc2NoZW1hKCkge1xuICAgIHJldHVybiB7XG4gICAgICBhdHRyczoge1xuICAgICAgICBsZXZlbDoge1xuICAgICAgICAgIGRlZmF1bHQ6IDFcbiAgICAgICAgfVxuICAgICAgfSxcbiAgICAgIGNvbnRlbnQ6ICdpbmxpbmUqJyxcbiAgICAgIGdyb3VwOiAnYmxvY2snLFxuICAgICAgZGVmaW5pbmc6IHRydWUsXG4gICAgICBkcmFnZ2FibGU6IGZhbHNlLFxuICAgICAgcGFyc2VET006IHRoaXMub3B0aW9ucy5sZXZlbHMubWFwKChsZXZlbDogbnVtYmVyKSA9PiAoe1xuICAgICAgICB0YWc6IGBoJHtsZXZlbH1gLFxuICAgICAgICBhdHRyczogeyBsZXZlbCB9XG4gICAgICB9KSksXG4gICAgICB0b0RPTTogKG5vZGU6IFBNTm9kZSkgPT4gW2BoJHtub2RlLmF0dHJzLmxldmVsfWAsIDBdXG4gICAgfVxuICB9XG5cbiAgY29tbWFuZHMoeyB0eXBlLCBzY2hlbWEgfTogUE1Ob2RlKSB7XG4gICAgcmV0dXJuIChhdHRyczoge30pID0+IHRvZ2dsZUJsb2NrVHlwZSh0eXBlLCBzY2hlbWEubm9kZXMucGFyYWdyYXBoLCBhdHRycylcbiAgfVxuXG4gIGtleXMoeyB0eXBlIH06IFBNTm9kZSkge1xuICAgIHJldHVybiB0aGlzLm9wdGlvbnMubGV2ZWxzLnJlZHVjZShcbiAgICAgIChpdGVtcywgbGV2ZWwpID0+ICh7XG4gICAgICAgIC4uLml0ZW1zLFxuICAgICAgICAuLi57XG4gICAgICAgICAgW2BTaGlmdC1DdHJsLSR7bGV2ZWx9YF06IHNldEJsb2NrVHlwZSh0eXBlLCB7IGxldmVsIH0pXG4gICAgICAgIH1cbiAgICAgIH0pLFxuICAgICAge31cbiAgICApXG4gIH1cblxuICBpbnB1dFJ1bGVzKHsgdHlwZSB9OiBQTU5vZGUpIHtcbiAgICByZXR1cm4gdGhpcy5vcHRpb25zLmxldmVscy5tYXAobGV2ZWwgPT5cbiAgICAgIHRleHRibG9ja1R5cGVJbnB1dFJ1bGUobmV3IFJlZ0V4cChgXigjezEsJHtsZXZlbH19KVxcXFxzJGApLCB0eXBlLCAoKSA9PiAoe1xuICAgICAgICBsZXZlbFxuICAgICAgfSkpXG4gICAgKVxuICB9XG59XG4iXX0=