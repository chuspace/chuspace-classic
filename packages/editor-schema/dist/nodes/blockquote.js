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
import { toggleWrap } from '@chuspace/editor-commands';
import { wrappingInputRule } from 'prosemirror-inputrules';

var Blockquote =
/*#__PURE__*/
function (_Node) {
  _inherits(Blockquote, _Node);

  function Blockquote() {
    var _getPrototypeOf2;

    var _this;

    _classCallCheck(this, Blockquote);

    for (var _len = arguments.length, args = new Array(_len), _key = 0; _key < _len; _key++) {
      args[_key] = arguments[_key];
    }

    _this = _possibleConstructorReturn(this, (_getPrototypeOf2 = _getPrototypeOf(Blockquote)).call.apply(_getPrototypeOf2, [this].concat(args)));
    _this.name = 'blockquote';
    return _this;
  }

  _createClass(Blockquote, [{
    key: "commands",
    value: function commands(_ref) {
      var type = _ref.type,
          schema = _ref.schema;
      return function () {
        return toggleWrap(type);
      };
    }
  }, {
    key: "keys",
    value: function keys(_ref2) {
      var type = _ref2.type;
      return {
        'Ctrl->': toggleWrap(type)
      };
    }
  }, {
    key: "inputRules",
    value: function inputRules(_ref3) {
      var type = _ref3.type;
      return [wrappingInputRule(/^\s*>\s$/, type)];
    }
  }, {
    key: "schema",
    get: function get() {
      return {
        content: 'block*',
        group: 'block',
        defining: true,
        draggable: false,
        parseDOM: [{
          tag: 'blockquote'
        }],
        toDOM: function toDOM() {
          return ['blockquote', 0];
        }
      };
    }
  }]);

  return Blockquote;
}(Node);

export { Blockquote as default };
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uL2xpYi9ub2Rlcy9ibG9ja3F1b3RlLmpzIl0sIm5hbWVzIjpbIk5vZGUiLCJQTU5vZGUiLCJ0b2dnbGVXcmFwIiwid3JhcHBpbmdJbnB1dFJ1bGUiLCJCbG9ja3F1b3RlIiwibmFtZSIsInR5cGUiLCJzY2hlbWEiLCJjb250ZW50IiwiZ3JvdXAiLCJkZWZpbmluZyIsImRyYWdnYWJsZSIsInBhcnNlRE9NIiwidGFnIiwidG9ET00iXSwibWFwcGluZ3MiOiI7Ozs7Ozs7Ozs7Ozs7Ozs7QUFFQSxTQUFTQSxJQUFULFFBQXFCLHVCQUFyQjtBQUNBLFNBQVNBLElBQUksSUFBSUMsTUFBakIsUUFBK0IsbUJBQS9CO0FBQ0EsU0FBU0MsVUFBVCxRQUEyQiwyQkFBM0I7QUFDQSxTQUFTQyxpQkFBVCxRQUFrQyx3QkFBbEM7O0lBRXFCQyxVOzs7Ozs7Ozs7Ozs7Ozs7OztVQUNuQkMsSSxHQUFPLFk7Ozs7OzttQ0FhNEI7QUFBQSxVQUF4QkMsSUFBd0IsUUFBeEJBLElBQXdCO0FBQUEsVUFBbEJDLE1BQWtCLFFBQWxCQSxNQUFrQjtBQUNqQyxhQUFPO0FBQUEsZUFBTUwsVUFBVSxDQUFDSSxJQUFELENBQWhCO0FBQUEsT0FBUDtBQUNEOzs7Z0NBRXNCO0FBQUEsVUFBaEJBLElBQWdCLFNBQWhCQSxJQUFnQjtBQUNyQixhQUFPO0FBQ0wsa0JBQVVKLFVBQVUsQ0FBQ0ksSUFBRDtBQURmLE9BQVA7QUFHRDs7O3NDQUU0QjtBQUFBLFVBQWhCQSxJQUFnQixTQUFoQkEsSUFBZ0I7QUFDM0IsYUFBTyxDQUFDSCxpQkFBaUIsQ0FBQyxVQUFELEVBQWFHLElBQWIsQ0FBbEIsQ0FBUDtBQUNEOzs7d0JBdkJZO0FBQ1gsYUFBTztBQUNMRSxRQUFBQSxPQUFPLEVBQUUsUUFESjtBQUVMQyxRQUFBQSxLQUFLLEVBQUUsT0FGRjtBQUdMQyxRQUFBQSxRQUFRLEVBQUUsSUFITDtBQUlMQyxRQUFBQSxTQUFTLEVBQUUsS0FKTjtBQUtMQyxRQUFBQSxRQUFRLEVBQUUsQ0FBQztBQUFFQyxVQUFBQSxHQUFHLEVBQUU7QUFBUCxTQUFELENBTEw7QUFNTEMsUUFBQUEsS0FBSyxFQUFFO0FBQUEsaUJBQU0sQ0FBQyxZQUFELEVBQWUsQ0FBZixDQUFOO0FBQUE7QUFORixPQUFQO0FBUUQ7Ozs7RUFacUNkLEk7O1NBQW5CSSxVIiwic291cmNlc0NvbnRlbnQiOlsiLy8gQGZsb3dcblxuaW1wb3J0IHsgTm9kZSB9IGZyb20gJ0BjaHVzcGFjZS9lZGl0b3ItYmFzZSdcbmltcG9ydCB7IE5vZGUgYXMgUE1Ob2RlIH0gZnJvbSAncHJvc2VtaXJyb3ItbW9kZWwnXG5pbXBvcnQgeyB0b2dnbGVXcmFwIH0gZnJvbSAnQGNodXNwYWNlL2VkaXRvci1jb21tYW5kcydcbmltcG9ydCB7IHdyYXBwaW5nSW5wdXRSdWxlIH0gZnJvbSAncHJvc2VtaXJyb3ItaW5wdXRydWxlcydcblxuZXhwb3J0IGRlZmF1bHQgY2xhc3MgQmxvY2txdW90ZSBleHRlbmRzIE5vZGUge1xuICBuYW1lID0gJ2Jsb2NrcXVvdGUnXG5cbiAgZ2V0IHNjaGVtYSgpIHtcbiAgICByZXR1cm4ge1xuICAgICAgY29udGVudDogJ2Jsb2NrKicsXG4gICAgICBncm91cDogJ2Jsb2NrJyxcbiAgICAgIGRlZmluaW5nOiB0cnVlLFxuICAgICAgZHJhZ2dhYmxlOiBmYWxzZSxcbiAgICAgIHBhcnNlRE9NOiBbeyB0YWc6ICdibG9ja3F1b3RlJyB9XSxcbiAgICAgIHRvRE9NOiAoKSA9PiBbJ2Jsb2NrcXVvdGUnLCAwXVxuICAgIH1cbiAgfVxuXG4gIGNvbW1hbmRzKHsgdHlwZSwgc2NoZW1hIH06IFBNTm9kZSkge1xuICAgIHJldHVybiAoKSA9PiB0b2dnbGVXcmFwKHR5cGUpXG4gIH1cblxuICBrZXlzKHsgdHlwZSB9OiBQTU5vZGUpIHtcbiAgICByZXR1cm4ge1xuICAgICAgJ0N0cmwtPic6IHRvZ2dsZVdyYXAodHlwZSlcbiAgICB9XG4gIH1cblxuICBpbnB1dFJ1bGVzKHsgdHlwZSB9OiBQTU5vZGUpIHtcbiAgICByZXR1cm4gW3dyYXBwaW5nSW5wdXRSdWxlKC9eXFxzKj5cXHMkLywgdHlwZSldXG4gIH1cbn1cbiJdfQ==