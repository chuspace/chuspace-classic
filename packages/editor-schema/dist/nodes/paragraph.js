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
import { setBlockType } from 'prosemirror-commands';

var Paragraph =
/*#__PURE__*/
function (_Node) {
  _inherits(Paragraph, _Node);

  function Paragraph() {
    var _getPrototypeOf2;

    var _this;

    _classCallCheck(this, Paragraph);

    for (var _len = arguments.length, args = new Array(_len), _key = 0; _key < _len; _key++) {
      args[_key] = arguments[_key];
    }

    _this = _possibleConstructorReturn(this, (_getPrototypeOf2 = _getPrototypeOf(Paragraph)).call.apply(_getPrototypeOf2, [this].concat(args)));
    _this.name = 'paragraph';
    return _this;
  }

  _createClass(Paragraph, [{
    key: "commands",
    value: function commands(_ref) {
      var type = _ref.type;
      return function () {
        return setBlockType(type);
      };
    }
  }, {
    key: "schema",
    get: function get() {
      return {
        content: 'inline*',
        group: 'block',
        draggable: false,
        parseDOM: [{
          tag: 'p'
        }],
        toDOM: function toDOM() {
          return ['p', 0];
        }
      };
    }
  }]);

  return Paragraph;
}(Node);

export { Paragraph as default };
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uL2xpYi9ub2Rlcy9wYXJhZ3JhcGguanMiXSwibmFtZXMiOlsiTm9kZSIsIlBNTm9kZSIsInNldEJsb2NrVHlwZSIsIlBhcmFncmFwaCIsIm5hbWUiLCJ0eXBlIiwiY29udGVudCIsImdyb3VwIiwiZHJhZ2dhYmxlIiwicGFyc2VET00iLCJ0YWciLCJ0b0RPTSJdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7Ozs7Ozs7OztBQUVBLFNBQVNBLElBQVQsUUFBcUIsdUJBQXJCO0FBQ0EsU0FBU0EsSUFBSSxJQUFJQyxNQUFqQixRQUErQixtQkFBL0I7QUFDQSxTQUFTQyxZQUFULFFBQTZCLHNCQUE3Qjs7SUFFcUJDLFM7Ozs7Ozs7Ozs7Ozs7Ozs7O1VBQ25CQyxJLEdBQU8sVzs7Ozs7O21DQWdCb0I7QUFBQSxVQUFoQkMsSUFBZ0IsUUFBaEJBLElBQWdCO0FBQ3pCLGFBQU87QUFBQSxlQUFNSCxZQUFZLENBQUNHLElBQUQsQ0FBbEI7QUFBQSxPQUFQO0FBQ0Q7Ozt3QkFoQlk7QUFDWCxhQUFPO0FBQ0xDLFFBQUFBLE9BQU8sRUFBRSxTQURKO0FBRUxDLFFBQUFBLEtBQUssRUFBRSxPQUZGO0FBR0xDLFFBQUFBLFNBQVMsRUFBRSxLQUhOO0FBSUxDLFFBQUFBLFFBQVEsRUFBRSxDQUNSO0FBQ0VDLFVBQUFBLEdBQUcsRUFBRTtBQURQLFNBRFEsQ0FKTDtBQVNMQyxRQUFBQSxLQUFLLEVBQUU7QUFBQSxpQkFBTSxDQUFDLEdBQUQsRUFBTSxDQUFOLENBQU47QUFBQTtBQVRGLE9BQVA7QUFXRDs7OztFQWZvQ1gsSTs7U0FBbEJHLFMiLCJzb3VyY2VzQ29udGVudCI6WyIvLyBAZmxvd1xuXG5pbXBvcnQgeyBOb2RlIH0gZnJvbSAnQGNodXNwYWNlL2VkaXRvci1iYXNlJ1xuaW1wb3J0IHsgTm9kZSBhcyBQTU5vZGUgfSBmcm9tICdwcm9zZW1pcnJvci1tb2RlbCdcbmltcG9ydCB7IHNldEJsb2NrVHlwZSB9IGZyb20gJ3Byb3NlbWlycm9yLWNvbW1hbmRzJ1xuXG5leHBvcnQgZGVmYXVsdCBjbGFzcyBQYXJhZ3JhcGggZXh0ZW5kcyBOb2RlIHtcbiAgbmFtZSA9ICdwYXJhZ3JhcGgnXG5cbiAgZ2V0IHNjaGVtYSgpIHtcbiAgICByZXR1cm4ge1xuICAgICAgY29udGVudDogJ2lubGluZSonLFxuICAgICAgZ3JvdXA6ICdibG9jaycsXG4gICAgICBkcmFnZ2FibGU6IGZhbHNlLFxuICAgICAgcGFyc2VET006IFtcbiAgICAgICAge1xuICAgICAgICAgIHRhZzogJ3AnXG4gICAgICAgIH1cbiAgICAgIF0sXG4gICAgICB0b0RPTTogKCkgPT4gWydwJywgMF1cbiAgICB9XG4gIH1cblxuICBjb21tYW5kcyh7IHR5cGUgfTogUE1Ob2RlKSB7XG4gICAgcmV0dXJuICgpID0+IHNldEJsb2NrVHlwZSh0eXBlKVxuICB9XG59XG4iXX0=