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

import { Plugin, TextSelection } from 'prosemirror-state';
import { pasteRule, removeMark, updateMark } from '@chuspace/editor-commands';
import { Mark } from '@chuspace/editor-base';
import { Mark as PMMark } from 'prosemirror-model';
import { getMarkRange } from '@chuspace/editor-helpers';

var Link =
/*#__PURE__*/
function (_Mark) {
  _inherits(Link, _Mark);

  function Link() {
    var _getPrototypeOf2;

    var _this;

    _classCallCheck(this, Link);

    for (var _len = arguments.length, args = new Array(_len), _key = 0; _key < _len; _key++) {
      args[_key] = arguments[_key];
    }

    _this = _possibleConstructorReturn(this, (_getPrototypeOf2 = _getPrototypeOf(Link)).call.apply(_getPrototypeOf2, [this].concat(args)));
    _this.name = 'link';
    return _this;
  }

  _createClass(Link, [{
    key: "commands",
    value: function commands(_ref) {
      var type = _ref.type;
      return function (attrs) {
        if (attrs.href) {
          return updateMark(type, attrs);
        }

        return removeMark(type);
      };
    }
  }, {
    key: "pasteRules",
    value: function pasteRules(_ref2) {
      var type = _ref2.type;
      return [pasteRule(/https?:\/\/(www\.)?[-a-zA-Z0-9@:%._+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_+.~#?&//=]*)/g, type, function (url) {
        return {
          href: url
        };
      })];
    }
  }, {
    key: "schema",
    get: function get() {
      return {
        attrs: {
          href: {
            "default": null
          }
        },
        inclusive: false,
        parseDOM: [{
          tag: 'a[href]',
          getAttrs: function getAttrs(dom) {
            return {
              href: dom.getAttribute('href')
            };
          }
        }],
        toDOM: function toDOM(mark) {
          return ['a', _objectSpread({}, mark.attrs, {
            rel: 'noopener noreferrer nofollow'
          }), 0];
        }
      };
    }
  }, {
    key: "plugins",
    get: function get() {
      return [new Plugin({
        props: {
          handleClick: function handleClick(view, pos) {
            var _view$state = view.state,
                schema = _view$state.schema,
                doc = _view$state.doc,
                tr = _view$state.tr;
            var range = getMarkRange(doc.resolve(pos), schema.marks.link);

            if (!range) {
              return;
            }

            var $start = doc.resolve(range.from);
            var $end = doc.resolve(range.to);
            var transaction = tr.setSelection(new TextSelection($start, $end));
            view.dispatch(transaction);
          }
        }
      })];
    }
  }]);

  return Link;
}(Mark);

export { Link as default };
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uL2xpYi9tYXJrcy9saW5rLmpzIl0sIm5hbWVzIjpbIlBsdWdpbiIsIlRleHRTZWxlY3Rpb24iLCJwYXN0ZVJ1bGUiLCJyZW1vdmVNYXJrIiwidXBkYXRlTWFyayIsIk1hcmsiLCJQTU1hcmsiLCJnZXRNYXJrUmFuZ2UiLCJMaW5rIiwibmFtZSIsInR5cGUiLCJhdHRycyIsImhyZWYiLCJ1cmwiLCJpbmNsdXNpdmUiLCJwYXJzZURPTSIsInRhZyIsImdldEF0dHJzIiwiZG9tIiwiZ2V0QXR0cmlidXRlIiwidG9ET00iLCJtYXJrIiwicmVsIiwicHJvcHMiLCJoYW5kbGVDbGljayIsInZpZXciLCJwb3MiLCJzdGF0ZSIsInNjaGVtYSIsImRvYyIsInRyIiwicmFuZ2UiLCJyZXNvbHZlIiwibWFya3MiLCJsaW5rIiwiJHN0YXJ0IiwiZnJvbSIsIiRlbmQiLCJ0byIsInRyYW5zYWN0aW9uIiwic2V0U2VsZWN0aW9uIiwiZGlzcGF0Y2giXSwibWFwcGluZ3MiOiI7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7O0FBRUEsU0FBU0EsTUFBVCxFQUFpQkMsYUFBakIsUUFBc0MsbUJBQXRDO0FBQ0EsU0FBU0MsU0FBVCxFQUFvQkMsVUFBcEIsRUFBZ0NDLFVBQWhDLFFBQWtELDJCQUFsRDtBQUVBLFNBQVNDLElBQVQsUUFBcUIsdUJBQXJCO0FBQ0EsU0FBU0EsSUFBSSxJQUFJQyxNQUFqQixRQUErQixtQkFBL0I7QUFDQSxTQUFTQyxZQUFULFFBQTZCLDBCQUE3Qjs7SUFFcUJDLEk7Ozs7Ozs7Ozs7Ozs7Ozs7O1VBQ25CQyxJLEdBQU8sTTs7Ozs7O21DQTZCb0I7QUFBQSxVQUFoQkMsSUFBZ0IsUUFBaEJBLElBQWdCO0FBQ3pCLGFBQU8sVUFBQ0MsS0FBRCxFQUFnQjtBQUNyQixZQUFJQSxLQUFLLENBQUNDLElBQVYsRUFBZ0I7QUFDZCxpQkFBT1IsVUFBVSxDQUFDTSxJQUFELEVBQU9DLEtBQVAsQ0FBakI7QUFDRDs7QUFFRCxlQUFPUixVQUFVLENBQUNPLElBQUQsQ0FBakI7QUFDRCxPQU5EO0FBT0Q7OztzQ0FFNEI7QUFBQSxVQUFoQkEsSUFBZ0IsU0FBaEJBLElBQWdCO0FBQzNCLGFBQU8sQ0FDTFIsU0FBUyxDQUNQLDRGQURPLEVBRVBRLElBRk8sRUFHUCxVQUFBRyxHQUFHO0FBQUEsZUFBSztBQUFFRCxVQUFBQSxJQUFJLEVBQUVDO0FBQVIsU0FBTDtBQUFBLE9BSEksQ0FESixDQUFQO0FBT0Q7Ozt3QkE3Q1k7QUFDWCxhQUFPO0FBQ0xGLFFBQUFBLEtBQUssRUFBRTtBQUNMQyxVQUFBQSxJQUFJLEVBQUU7QUFDSix1QkFBUztBQURMO0FBREQsU0FERjtBQU1MRSxRQUFBQSxTQUFTLEVBQUUsS0FOTjtBQU9MQyxRQUFBQSxRQUFRLEVBQUUsQ0FDUjtBQUNFQyxVQUFBQSxHQUFHLEVBQUUsU0FEUDtBQUVFQyxVQUFBQSxRQUFRLEVBQUUsa0JBQUNDLEdBQUQ7QUFBQSxtQkFBa0I7QUFDMUJOLGNBQUFBLElBQUksRUFBRU0sR0FBRyxDQUFDQyxZQUFKLENBQWlCLE1BQWpCO0FBRG9CLGFBQWxCO0FBQUE7QUFGWixTQURRLENBUEw7QUFlTEMsUUFBQUEsS0FBSyxFQUFFLGVBQUNDLElBQUQ7QUFBQSxpQkFBa0IsQ0FDdkIsR0FEdUIsb0JBR2xCQSxJQUFJLENBQUNWLEtBSGE7QUFJckJXLFlBQUFBLEdBQUcsRUFBRTtBQUpnQixjQU12QixDQU51QixDQUFsQjtBQUFBO0FBZkYsT0FBUDtBQXdCRDs7O3dCQXNCYTtBQUNaLGFBQU8sQ0FDTCxJQUFJdEIsTUFBSixDQUFXO0FBQ1R1QixRQUFBQSxLQUFLLEVBQUU7QUFDTEMsVUFBQUEsV0FESyx1QkFDT0MsSUFEUCxFQUNhQyxHQURiLEVBQ2tCO0FBQUEsOEJBQ09ELElBQUksQ0FBQ0UsS0FEWjtBQUFBLGdCQUNiQyxNQURhLGVBQ2JBLE1BRGE7QUFBQSxnQkFDTEMsR0FESyxlQUNMQSxHQURLO0FBQUEsZ0JBQ0FDLEVBREEsZUFDQUEsRUFEQTtBQUVyQixnQkFBTUMsS0FBSyxHQUFHeEIsWUFBWSxDQUFDc0IsR0FBRyxDQUFDRyxPQUFKLENBQVlOLEdBQVosQ0FBRCxFQUFtQkUsTUFBTSxDQUFDSyxLQUFQLENBQWFDLElBQWhDLENBQTFCOztBQUVBLGdCQUFJLENBQUNILEtBQUwsRUFBWTtBQUNWO0FBQ0Q7O0FBRUQsZ0JBQU1JLE1BQU0sR0FBR04sR0FBRyxDQUFDRyxPQUFKLENBQVlELEtBQUssQ0FBQ0ssSUFBbEIsQ0FBZjtBQUNBLGdCQUFNQyxJQUFJLEdBQUdSLEdBQUcsQ0FBQ0csT0FBSixDQUFZRCxLQUFLLENBQUNPLEVBQWxCLENBQWI7QUFDQSxnQkFBTUMsV0FBVyxHQUFHVCxFQUFFLENBQUNVLFlBQUgsQ0FBZ0IsSUFBSXZDLGFBQUosQ0FBa0JrQyxNQUFsQixFQUEwQkUsSUFBMUIsQ0FBaEIsQ0FBcEI7QUFFQVosWUFBQUEsSUFBSSxDQUFDZ0IsUUFBTCxDQUFjRixXQUFkO0FBQ0Q7QUFkSTtBQURFLE9BQVgsQ0FESyxDQUFQO0FBb0JEOzs7O0VBdkUrQmxDLEk7O1NBQWJHLEkiLCJzb3VyY2VzQ29udGVudCI6WyIvLyBAZmxvd1xuXG5pbXBvcnQgeyBQbHVnaW4sIFRleHRTZWxlY3Rpb24gfSBmcm9tICdwcm9zZW1pcnJvci1zdGF0ZSdcbmltcG9ydCB7IHBhc3RlUnVsZSwgcmVtb3ZlTWFyaywgdXBkYXRlTWFyayB9IGZyb20gJ0BjaHVzcGFjZS9lZGl0b3ItY29tbWFuZHMnXG5cbmltcG9ydCB7IE1hcmsgfSBmcm9tICdAY2h1c3BhY2UvZWRpdG9yLWJhc2UnXG5pbXBvcnQgeyBNYXJrIGFzIFBNTWFyayB9IGZyb20gJ3Byb3NlbWlycm9yLW1vZGVsJ1xuaW1wb3J0IHsgZ2V0TWFya1JhbmdlIH0gZnJvbSAnQGNodXNwYWNlL2VkaXRvci1oZWxwZXJzJ1xuXG5leHBvcnQgZGVmYXVsdCBjbGFzcyBMaW5rIGV4dGVuZHMgTWFyayB7XG4gIG5hbWUgPSAnbGluaydcblxuICBnZXQgc2NoZW1hKCkge1xuICAgIHJldHVybiB7XG4gICAgICBhdHRyczoge1xuICAgICAgICBocmVmOiB7XG4gICAgICAgICAgZGVmYXVsdDogbnVsbFxuICAgICAgICB9XG4gICAgICB9LFxuICAgICAgaW5jbHVzaXZlOiBmYWxzZSxcbiAgICAgIHBhcnNlRE9NOiBbXG4gICAgICAgIHtcbiAgICAgICAgICB0YWc6ICdhW2hyZWZdJyxcbiAgICAgICAgICBnZXRBdHRyczogKGRvbTogUE1NYXJrKSA9PiAoe1xuICAgICAgICAgICAgaHJlZjogZG9tLmdldEF0dHJpYnV0ZSgnaHJlZicpXG4gICAgICAgICAgfSlcbiAgICAgICAgfVxuICAgICAgXSxcbiAgICAgIHRvRE9NOiAobWFyazogUE1NYXJrKSA9PiBbXG4gICAgICAgICdhJyxcbiAgICAgICAge1xuICAgICAgICAgIC4uLm1hcmsuYXR0cnMsXG4gICAgICAgICAgcmVsOiAnbm9vcGVuZXIgbm9yZWZlcnJlciBub2ZvbGxvdydcbiAgICAgICAgfSxcbiAgICAgICAgMFxuICAgICAgXVxuICAgIH1cbiAgfVxuXG4gIGNvbW1hbmRzKHsgdHlwZSB9OiBQTU1hcmspIHtcbiAgICByZXR1cm4gKGF0dHJzOiBhbnkpID0+IHtcbiAgICAgIGlmIChhdHRycy5ocmVmKSB7XG4gICAgICAgIHJldHVybiB1cGRhdGVNYXJrKHR5cGUsIGF0dHJzKVxuICAgICAgfVxuXG4gICAgICByZXR1cm4gcmVtb3ZlTWFyayh0eXBlKVxuICAgIH1cbiAgfVxuXG4gIHBhc3RlUnVsZXMoeyB0eXBlIH06IFBNTWFyaykge1xuICAgIHJldHVybiBbXG4gICAgICBwYXN0ZVJ1bGUoXG4gICAgICAgIC9odHRwcz86XFwvXFwvKHd3d1xcLik/Wy1hLXpBLVowLTlAOiUuXyt+Iz1dezIsMjU2fVxcLlthLXpdezIsNn1cXGIoWy1hLXpBLVowLTlAOiVfKy5+Iz8mLy89XSopL2csXG4gICAgICAgIHR5cGUsXG4gICAgICAgIHVybCA9PiAoeyBocmVmOiB1cmwgfSlcbiAgICAgIClcbiAgICBdXG4gIH1cblxuICBnZXQgcGx1Z2lucygpIHtcbiAgICByZXR1cm4gW1xuICAgICAgbmV3IFBsdWdpbih7XG4gICAgICAgIHByb3BzOiB7XG4gICAgICAgICAgaGFuZGxlQ2xpY2sodmlldywgcG9zKSB7XG4gICAgICAgICAgICBjb25zdCB7IHNjaGVtYSwgZG9jLCB0ciB9ID0gdmlldy5zdGF0ZVxuICAgICAgICAgICAgY29uc3QgcmFuZ2UgPSBnZXRNYXJrUmFuZ2UoZG9jLnJlc29sdmUocG9zKSwgc2NoZW1hLm1hcmtzLmxpbmspXG5cbiAgICAgICAgICAgIGlmICghcmFuZ2UpIHtcbiAgICAgICAgICAgICAgcmV0dXJuXG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICAgIGNvbnN0ICRzdGFydCA9IGRvYy5yZXNvbHZlKHJhbmdlLmZyb20pXG4gICAgICAgICAgICBjb25zdCAkZW5kID0gZG9jLnJlc29sdmUocmFuZ2UudG8pXG4gICAgICAgICAgICBjb25zdCB0cmFuc2FjdGlvbiA9IHRyLnNldFNlbGVjdGlvbihuZXcgVGV4dFNlbGVjdGlvbigkc3RhcnQsICRlbmQpKVxuXG4gICAgICAgICAgICB2aWV3LmRpc3BhdGNoKHRyYW5zYWN0aW9uKVxuICAgICAgICAgIH1cbiAgICAgICAgfVxuICAgICAgfSlcbiAgICBdXG4gIH1cbn1cbiJdfQ==