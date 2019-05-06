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

var OrderedList =
/*#__PURE__*/
function (_Node) {
  _inherits(OrderedList, _Node);

  function OrderedList() {
    var _getPrototypeOf2;

    var _this;

    _classCallCheck(this, OrderedList);

    for (var _len = arguments.length, args = new Array(_len), _key = 0; _key < _len; _key++) {
      args[_key] = arguments[_key];
    }

    _this = _possibleConstructorReturn(this, (_getPrototypeOf2 = _getPrototypeOf(OrderedList)).call.apply(_getPrototypeOf2, [this].concat(args)));
    _this.name = 'ordered_list';
    return _this;
  }

  _createClass(OrderedList, [{
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
        'Shift-Ctrl-9': toggleList(type, schema.nodes.list_item)
      };
    }
  }, {
    key: "inputRules",
    value: function inputRules(_ref3) {
      var type = _ref3.type;
      return [wrappingInputRule(/^(\d+)\.\s$/, type, function (match) {
        return {
          order: +match[1]
        };
      }, function (match, node) {
        return node.childCount + node.attrs.order === +match[1];
      })];
    }
  }, {
    key: "schema",
    get: function get() {
      return {
        attrs: {
          order: {
            "default": 1
          }
        },
        content: 'list_item+',
        group: 'block',
        parseDOM: [{
          tag: 'ol',
          getAttrs: function getAttrs(dom) {
            return {
              order: dom.hasAttribute('start') ? +dom.getAttribute('start') : 1
            };
          }
        }],
        toDOM: function toDOM(node) {
          return node.attrs.order === 1 ? ['ol', 0] : ['ol', {
            start: node.attrs.order
          }, 0];
        }
      };
    }
  }]);

  return OrderedList;
}(Node);

export { OrderedList as default };
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uL2xpYi9ub2Rlcy9vcmRlcmVkLWxpc3QuanMiXSwibmFtZXMiOlsiTm9kZSIsIlBNTm9kZSIsInRvZ2dsZUxpc3QiLCJ3cmFwcGluZ0lucHV0UnVsZSIsIk9yZGVyZWRMaXN0IiwibmFtZSIsInR5cGUiLCJzY2hlbWEiLCJub2RlcyIsImxpc3RfaXRlbSIsIm1hdGNoIiwib3JkZXIiLCJub2RlIiwiY2hpbGRDb3VudCIsImF0dHJzIiwiY29udGVudCIsImdyb3VwIiwicGFyc2VET00iLCJ0YWciLCJnZXRBdHRycyIsImRvbSIsImhhc0F0dHJpYnV0ZSIsImdldEF0dHJpYnV0ZSIsInRvRE9NIiwic3RhcnQiXSwibWFwcGluZ3MiOiI7Ozs7Ozs7Ozs7Ozs7Ozs7QUFFQSxTQUFTQSxJQUFULFFBQXFCLHVCQUFyQjtBQUNBLFNBQVNBLElBQUksSUFBSUMsTUFBakIsUUFBK0IsbUJBQS9CO0FBQ0EsU0FBU0MsVUFBVCxRQUEyQiwyQkFBM0I7QUFDQSxTQUFTQyxpQkFBVCxRQUFrQyx3QkFBbEM7O0lBRXFCQyxXOzs7Ozs7Ozs7Ozs7Ozs7OztVQUNuQkMsSSxHQUFPLGM7Ozs7OzttQ0F1QjRCO0FBQUEsVUFBeEJDLElBQXdCLFFBQXhCQSxJQUF3QjtBQUFBLFVBQWxCQyxNQUFrQixRQUFsQkEsTUFBa0I7QUFDakMsYUFBTztBQUFBLGVBQU1MLFVBQVUsQ0FBQ0ksSUFBRCxFQUFPQyxNQUFNLENBQUNDLEtBQVAsQ0FBYUMsU0FBcEIsQ0FBaEI7QUFBQSxPQUFQO0FBQ0Q7OztnQ0FFOEI7QUFBQSxVQUF4QkgsSUFBd0IsU0FBeEJBLElBQXdCO0FBQUEsVUFBbEJDLE1BQWtCLFNBQWxCQSxNQUFrQjtBQUM3QixhQUFPO0FBQ0wsd0JBQWdCTCxVQUFVLENBQUNJLElBQUQsRUFBT0MsTUFBTSxDQUFDQyxLQUFQLENBQWFDLFNBQXBCO0FBRHJCLE9BQVA7QUFHRDs7O3NDQUU0QjtBQUFBLFVBQWhCSCxJQUFnQixTQUFoQkEsSUFBZ0I7QUFDM0IsYUFBTyxDQUNMSCxpQkFBaUIsQ0FDZixhQURlLEVBRWZHLElBRmUsRUFHZixVQUFBSSxLQUFLO0FBQUEsZUFBSztBQUFFQyxVQUFBQSxLQUFLLEVBQUUsQ0FBQ0QsS0FBSyxDQUFDLENBQUQ7QUFBZixTQUFMO0FBQUEsT0FIVSxFQUlmLFVBQUNBLEtBQUQsRUFBUUUsSUFBUjtBQUFBLGVBQWlCQSxJQUFJLENBQUNDLFVBQUwsR0FBa0JELElBQUksQ0FBQ0UsS0FBTCxDQUFXSCxLQUE3QixLQUF1QyxDQUFDRCxLQUFLLENBQUMsQ0FBRCxDQUE5RDtBQUFBLE9BSmUsQ0FEWixDQUFQO0FBUUQ7Ozt3QkF4Q1k7QUFDWCxhQUFPO0FBQ0xJLFFBQUFBLEtBQUssRUFBRTtBQUNMSCxVQUFBQSxLQUFLLEVBQUU7QUFDTCx1QkFBUztBQURKO0FBREYsU0FERjtBQU1MSSxRQUFBQSxPQUFPLEVBQUUsWUFOSjtBQU9MQyxRQUFBQSxLQUFLLEVBQUUsT0FQRjtBQVFMQyxRQUFBQSxRQUFRLEVBQUUsQ0FDUjtBQUNFQyxVQUFBQSxHQUFHLEVBQUUsSUFEUDtBQUVFQyxVQUFBQSxRQUFRLEVBQUUsa0JBQUNDLEdBQUQ7QUFBQSxtQkFBa0I7QUFDMUJULGNBQUFBLEtBQUssRUFBRVMsR0FBRyxDQUFDQyxZQUFKLENBQWlCLE9BQWpCLElBQTRCLENBQUNELEdBQUcsQ0FBQ0UsWUFBSixDQUFpQixPQUFqQixDQUE3QixHQUF5RDtBQUR0QyxhQUFsQjtBQUFBO0FBRlosU0FEUSxDQVJMO0FBZ0JMQyxRQUFBQSxLQUFLLEVBQUUsZUFBQ1gsSUFBRDtBQUFBLGlCQUFtQkEsSUFBSSxDQUFDRSxLQUFMLENBQVdILEtBQVgsS0FBcUIsQ0FBckIsR0FBeUIsQ0FBQyxJQUFELEVBQU8sQ0FBUCxDQUF6QixHQUFxQyxDQUFDLElBQUQsRUFBTztBQUFFYSxZQUFBQSxLQUFLLEVBQUVaLElBQUksQ0FBQ0UsS0FBTCxDQUFXSDtBQUFwQixXQUFQLEVBQW9DLENBQXBDLENBQXhEO0FBQUE7QUFoQkYsT0FBUDtBQWtCRDs7OztFQXRCc0NYLEk7O1NBQXBCSSxXIiwic291cmNlc0NvbnRlbnQiOlsiLy8gQGZsb3dcblxuaW1wb3J0IHsgTm9kZSB9IGZyb20gJ0BjaHVzcGFjZS9lZGl0b3ItYmFzZSdcbmltcG9ydCB7IE5vZGUgYXMgUE1Ob2RlIH0gZnJvbSAncHJvc2VtaXJyb3ItbW9kZWwnXG5pbXBvcnQgeyB0b2dnbGVMaXN0IH0gZnJvbSAnQGNodXNwYWNlL2VkaXRvci1jb21tYW5kcydcbmltcG9ydCB7IHdyYXBwaW5nSW5wdXRSdWxlIH0gZnJvbSAncHJvc2VtaXJyb3ItaW5wdXRydWxlcydcblxuZXhwb3J0IGRlZmF1bHQgY2xhc3MgT3JkZXJlZExpc3QgZXh0ZW5kcyBOb2RlIHtcbiAgbmFtZSA9ICdvcmRlcmVkX2xpc3QnXG5cbiAgZ2V0IHNjaGVtYSgpIHtcbiAgICByZXR1cm4ge1xuICAgICAgYXR0cnM6IHtcbiAgICAgICAgb3JkZXI6IHtcbiAgICAgICAgICBkZWZhdWx0OiAxXG4gICAgICAgIH1cbiAgICAgIH0sXG4gICAgICBjb250ZW50OiAnbGlzdF9pdGVtKycsXG4gICAgICBncm91cDogJ2Jsb2NrJyxcbiAgICAgIHBhcnNlRE9NOiBbXG4gICAgICAgIHtcbiAgICAgICAgICB0YWc6ICdvbCcsXG4gICAgICAgICAgZ2V0QXR0cnM6IChkb206IFBNTm9kZSkgPT4gKHtcbiAgICAgICAgICAgIG9yZGVyOiBkb20uaGFzQXR0cmlidXRlKCdzdGFydCcpID8gK2RvbS5nZXRBdHRyaWJ1dGUoJ3N0YXJ0JykgOiAxXG4gICAgICAgICAgfSlcbiAgICAgICAgfVxuICAgICAgXSxcbiAgICAgIHRvRE9NOiAobm9kZTogUE1Ob2RlKSA9PiAobm9kZS5hdHRycy5vcmRlciA9PT0gMSA/IFsnb2wnLCAwXSA6IFsnb2wnLCB7IHN0YXJ0OiBub2RlLmF0dHJzLm9yZGVyIH0sIDBdKVxuICAgIH1cbiAgfVxuXG4gIGNvbW1hbmRzKHsgdHlwZSwgc2NoZW1hIH06IFBNTm9kZSkge1xuICAgIHJldHVybiAoKSA9PiB0b2dnbGVMaXN0KHR5cGUsIHNjaGVtYS5ub2Rlcy5saXN0X2l0ZW0pXG4gIH1cblxuICBrZXlzKHsgdHlwZSwgc2NoZW1hIH06IFBNTm9kZSkge1xuICAgIHJldHVybiB7XG4gICAgICAnU2hpZnQtQ3RybC05JzogdG9nZ2xlTGlzdCh0eXBlLCBzY2hlbWEubm9kZXMubGlzdF9pdGVtKVxuICAgIH1cbiAgfVxuXG4gIGlucHV0UnVsZXMoeyB0eXBlIH06IFBNTm9kZSkge1xuICAgIHJldHVybiBbXG4gICAgICB3cmFwcGluZ0lucHV0UnVsZShcbiAgICAgICAgL14oXFxkKylcXC5cXHMkLyxcbiAgICAgICAgdHlwZSxcbiAgICAgICAgbWF0Y2ggPT4gKHsgb3JkZXI6ICttYXRjaFsxXSB9KSxcbiAgICAgICAgKG1hdGNoLCBub2RlKSA9PiBub2RlLmNoaWxkQ291bnQgKyBub2RlLmF0dHJzLm9yZGVyID09PSArbWF0Y2hbMV1cbiAgICAgIClcbiAgICBdXG4gIH1cbn1cbiJdfQ==