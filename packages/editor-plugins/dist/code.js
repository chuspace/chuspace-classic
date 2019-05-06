function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance"); }

function _iterableToArrayLimit(arr, i) { var _arr = []; var _n = true; var _d = false; var _e = undefined; try { for (var _i = arr[Symbol.iterator](), _s; !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

function _possibleConstructorReturn(self, call) { if (call && (typeof call === "object" || typeof call === "function")) { return call; } return _assertThisInitialized(self); }

function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }

function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); if (superClass) _setPrototypeOf(subClass, superClass); }

function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf || function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }

import { Plugin, Selection } from 'prosemirror-state';
import { Element } from '@chuspace/editor-base';
import { nodeInputRule } from '@chuspace/editor-commands';

var Code =
/*#__PURE__*/
function (_Element) {
  _inherits(Code, _Element);

  function Code() {
    var _getPrototypeOf2;

    var _this;

    _classCallCheck(this, Code);

    for (var _len = arguments.length, args = new Array(_len), _key = 0; _key < _len; _key++) {
      args[_key] = arguments[_key];
    }

    _this = _possibleConstructorReturn(this, (_getPrototypeOf2 = _getPrototypeOf(Code)).call.apply(_getPrototypeOf2, [this].concat(args)));
    _this.name = 'code';
    return _this;
  }

  _createClass(Code, [{
    key: "plugins",
    get: function get() {
      return [new Plugin({
        props: {
          handleKeyDown: function handleKeyDown(view, event) {
            if (event.keyCode === 13) {
              var state = view.state;
              var schema = state.schema,
                  tr = state.tr;

              if (!state.selection.$cursor) {
                return false;
              }

              var _state$selection$$fro = state.selection.$from,
                  nodeBefore = _state$selection$$fro.nodeBefore,
                  pos = _state$selection$$fro.pos;

              if (!nodeBefore || !nodeBefore.isText) {
                return false;
              }

              var regex = /^```([a-zA-Z]*)?$/;
              var matches = nodeBefore.text.match(regex);

              if (matches) {
                var _matches = _slicedToArray(matches, 2),
                    language = _matches[1];

                var _tr = state.tr;
                var from = pos - matches[0].length;
                var to = pos;
                var text = matches[0];

                if (matches[0]) {
                  var node = schema.nodes.code_block.create({
                    language: language
                  });
                  var selection = Selection.near(state.doc.resolve(from), to);

                  _tr.replaceWith(pos - matches[0].length - 1, pos, node).setMeta(this, {
                    transform: _tr,
                    from: from,
                    to: to,
                    text: text
                  }).setSelection(selection).scrollIntoView();

                  view.dispatch(_tr);
                  return true;
                }
              }
            }

            return false; // We did not handle this
          }
        }
      })];
    }
  }]);

  return Code;
}(Element);

export { Code as default };
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uL2xpYi9jb2RlLmpzIl0sIm5hbWVzIjpbIlBsdWdpbiIsIlNlbGVjdGlvbiIsIkVsZW1lbnQiLCJub2RlSW5wdXRSdWxlIiwiQ29kZSIsIm5hbWUiLCJwcm9wcyIsImhhbmRsZUtleURvd24iLCJ2aWV3IiwiZXZlbnQiLCJrZXlDb2RlIiwic3RhdGUiLCJzY2hlbWEiLCJ0ciIsInNlbGVjdGlvbiIsIiRjdXJzb3IiLCIkZnJvbSIsIm5vZGVCZWZvcmUiLCJwb3MiLCJpc1RleHQiLCJyZWdleCIsIm1hdGNoZXMiLCJ0ZXh0IiwibWF0Y2giLCJsYW5ndWFnZSIsImZyb20iLCJsZW5ndGgiLCJ0byIsIm5vZGUiLCJub2RlcyIsImNvZGVfYmxvY2siLCJjcmVhdGUiLCJuZWFyIiwiZG9jIiwicmVzb2x2ZSIsInJlcGxhY2VXaXRoIiwic2V0TWV0YSIsInRyYW5zZm9ybSIsInNldFNlbGVjdGlvbiIsInNjcm9sbEludG9WaWV3IiwiZGlzcGF0Y2giXSwibWFwcGluZ3MiOiI7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7OztBQUVBLFNBQVNBLE1BQVQsRUFBaUJDLFNBQWpCLFFBQWtDLG1CQUFsQztBQUVBLFNBQVNDLE9BQVQsUUFBd0IsdUJBQXhCO0FBQ0EsU0FBU0MsYUFBVCxRQUE4QiwyQkFBOUI7O0lBRXFCQyxJOzs7Ozs7Ozs7Ozs7Ozs7OztVQUNuQkMsSSxHQUFPLE07Ozs7Ozt3QkFFTztBQUNaLGFBQU8sQ0FDTCxJQUFJTCxNQUFKLENBQVc7QUFDVE0sUUFBQUEsS0FBSyxFQUFFO0FBQ0xDLFVBQUFBLGFBREsseUJBQ1NDLElBRFQsRUFDZUMsS0FEZixFQUNzQjtBQUN6QixnQkFBSUEsS0FBSyxDQUFDQyxPQUFOLEtBQWtCLEVBQXRCLEVBQTBCO0FBQUEsa0JBQ2hCQyxLQURnQixHQUNOSCxJQURNLENBQ2hCRyxLQURnQjtBQUFBLGtCQUVoQkMsTUFGZ0IsR0FFREQsS0FGQyxDQUVoQkMsTUFGZ0I7QUFBQSxrQkFFUkMsRUFGUSxHQUVERixLQUZDLENBRVJFLEVBRlE7O0FBSXhCLGtCQUFJLENBQUNGLEtBQUssQ0FBQ0csU0FBTixDQUFnQkMsT0FBckIsRUFBOEI7QUFDNUIsdUJBQU8sS0FBUDtBQUNEOztBQU51QiwwQ0FRSUosS0FBSyxDQUFDRyxTQUFOLENBQWdCRSxLQVJwQjtBQUFBLGtCQVFoQkMsVUFSZ0IseUJBUWhCQSxVQVJnQjtBQUFBLGtCQVFKQyxHQVJJLHlCQVFKQSxHQVJJOztBQVV4QixrQkFBSSxDQUFDRCxVQUFELElBQWUsQ0FBQ0EsVUFBVSxDQUFDRSxNQUEvQixFQUF1QztBQUNyQyx1QkFBTyxLQUFQO0FBQ0Q7O0FBRUQsa0JBQU1DLEtBQUssR0FBRyxtQkFBZDtBQUNBLGtCQUFNQyxPQUFPLEdBQUdKLFVBQVUsQ0FBQ0ssSUFBWCxDQUFnQkMsS0FBaEIsQ0FBc0JILEtBQXRCLENBQWhCOztBQUVBLGtCQUFJQyxPQUFKLEVBQWE7QUFBQSw4Q0FDVUEsT0FEVjtBQUFBLG9CQUNGRyxRQURFOztBQUFBLG9CQUdIWCxHQUhHLEdBR0lGLEtBSEosQ0FHSEUsRUFIRztBQUtYLG9CQUFNWSxJQUFJLEdBQUdQLEdBQUcsR0FBR0csT0FBTyxDQUFDLENBQUQsQ0FBUCxDQUFXSyxNQUE5QjtBQUNBLG9CQUFNQyxFQUFFLEdBQUdULEdBQVg7QUFDQSxvQkFBTUksSUFBSSxHQUFHRCxPQUFPLENBQUMsQ0FBRCxDQUFwQjs7QUFFQSxvQkFBSUEsT0FBTyxDQUFDLENBQUQsQ0FBWCxFQUFnQjtBQUNkLHNCQUFNTyxJQUFJLEdBQUdoQixNQUFNLENBQUNpQixLQUFQLENBQWFDLFVBQWIsQ0FBd0JDLE1BQXhCLENBQStCO0FBQUVQLG9CQUFBQSxRQUFRLEVBQVJBO0FBQUYsbUJBQS9CLENBQWI7QUFDQSxzQkFBTVYsU0FBUyxHQUFHYixTQUFTLENBQUMrQixJQUFWLENBQWVyQixLQUFLLENBQUNzQixHQUFOLENBQVVDLE9BQVYsQ0FBa0JULElBQWxCLENBQWYsRUFBd0NFLEVBQXhDLENBQWxCOztBQUVBZCxrQkFBQUEsR0FBRSxDQUFDc0IsV0FBSCxDQUFlakIsR0FBRyxHQUFHRyxPQUFPLENBQUMsQ0FBRCxDQUFQLENBQVdLLE1BQWpCLEdBQTBCLENBQXpDLEVBQTRDUixHQUE1QyxFQUFpRFUsSUFBakQsRUFDR1EsT0FESCxDQUNXLElBRFgsRUFDaUI7QUFDYkMsb0JBQUFBLFNBQVMsRUFBRXhCLEdBREU7QUFFYlksb0JBQUFBLElBQUksRUFBSkEsSUFGYTtBQUdiRSxvQkFBQUEsRUFBRSxFQUFGQSxFQUhhO0FBSWJMLG9CQUFBQSxJQUFJLEVBQUpBO0FBSmEsbUJBRGpCLEVBT0dnQixZQVBILENBT2dCeEIsU0FQaEIsRUFRR3lCLGNBUkg7O0FBVUEvQixrQkFBQUEsSUFBSSxDQUFDZ0MsUUFBTCxDQUFjM0IsR0FBZDtBQUVBLHlCQUFPLElBQVA7QUFDRDtBQUNGO0FBQ0Y7O0FBRUQsbUJBQU8sS0FBUCxDQWhEeUIsQ0FnRFo7QUFDZDtBQWxESTtBQURFLE9BQVgsQ0FESyxDQUFQO0FBd0REOzs7O0VBNUQrQlgsTzs7U0FBYkUsSSIsInNvdXJjZXNDb250ZW50IjpbIi8vIEBmbG93XG5cbmltcG9ydCB7IFBsdWdpbiwgU2VsZWN0aW9uIH0gZnJvbSAncHJvc2VtaXJyb3Itc3RhdGUnXG5cbmltcG9ydCB7IEVsZW1lbnQgfSBmcm9tICdAY2h1c3BhY2UvZWRpdG9yLWJhc2UnXG5pbXBvcnQgeyBub2RlSW5wdXRSdWxlIH0gZnJvbSAnQGNodXNwYWNlL2VkaXRvci1jb21tYW5kcydcblxuZXhwb3J0IGRlZmF1bHQgY2xhc3MgQ29kZSBleHRlbmRzIEVsZW1lbnQge1xuICBuYW1lID0gJ2NvZGUnXG5cbiAgZ2V0IHBsdWdpbnMoKSB7XG4gICAgcmV0dXJuIFtcbiAgICAgIG5ldyBQbHVnaW4oe1xuICAgICAgICBwcm9wczoge1xuICAgICAgICAgIGhhbmRsZUtleURvd24odmlldywgZXZlbnQpIHtcbiAgICAgICAgICAgIGlmIChldmVudC5rZXlDb2RlID09PSAxMykge1xuICAgICAgICAgICAgICBjb25zdCB7IHN0YXRlIH0gPSB2aWV3XG4gICAgICAgICAgICAgIGNvbnN0IHsgc2NoZW1hLCB0ciB9ID0gc3RhdGVcblxuICAgICAgICAgICAgICBpZiAoIXN0YXRlLnNlbGVjdGlvbi4kY3Vyc29yKSB7XG4gICAgICAgICAgICAgICAgcmV0dXJuIGZhbHNlXG4gICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICBjb25zdCB7IG5vZGVCZWZvcmUsIHBvcyB9ID0gc3RhdGUuc2VsZWN0aW9uLiRmcm9tXG5cbiAgICAgICAgICAgICAgaWYgKCFub2RlQmVmb3JlIHx8ICFub2RlQmVmb3JlLmlzVGV4dCkge1xuICAgICAgICAgICAgICAgIHJldHVybiBmYWxzZVxuICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgY29uc3QgcmVnZXggPSAvXmBgYChbYS16QS1aXSopPyQvXG4gICAgICAgICAgICAgIGNvbnN0IG1hdGNoZXMgPSBub2RlQmVmb3JlLnRleHQubWF0Y2gocmVnZXgpXG5cbiAgICAgICAgICAgICAgaWYgKG1hdGNoZXMpIHtcbiAgICAgICAgICAgICAgICBjb25zdCBbLCBsYW5ndWFnZV0gPSBtYXRjaGVzXG5cbiAgICAgICAgICAgICAgICBjb25zdCB7IHRyIH0gPSBzdGF0ZVxuXG4gICAgICAgICAgICAgICAgY29uc3QgZnJvbSA9IHBvcyAtIG1hdGNoZXNbMF0ubGVuZ3RoXG4gICAgICAgICAgICAgICAgY29uc3QgdG8gPSBwb3NcbiAgICAgICAgICAgICAgICBjb25zdCB0ZXh0ID0gbWF0Y2hlc1swXVxuXG4gICAgICAgICAgICAgICAgaWYgKG1hdGNoZXNbMF0pIHtcbiAgICAgICAgICAgICAgICAgIGNvbnN0IG5vZGUgPSBzY2hlbWEubm9kZXMuY29kZV9ibG9jay5jcmVhdGUoeyBsYW5ndWFnZSB9KVxuICAgICAgICAgICAgICAgICAgY29uc3Qgc2VsZWN0aW9uID0gU2VsZWN0aW9uLm5lYXIoc3RhdGUuZG9jLnJlc29sdmUoZnJvbSksIHRvKVxuXG4gICAgICAgICAgICAgICAgICB0ci5yZXBsYWNlV2l0aChwb3MgLSBtYXRjaGVzWzBdLmxlbmd0aCAtIDEsIHBvcywgbm9kZSlcbiAgICAgICAgICAgICAgICAgICAgLnNldE1ldGEodGhpcywge1xuICAgICAgICAgICAgICAgICAgICAgIHRyYW5zZm9ybTogdHIsXG4gICAgICAgICAgICAgICAgICAgICAgZnJvbSxcbiAgICAgICAgICAgICAgICAgICAgICB0byxcbiAgICAgICAgICAgICAgICAgICAgICB0ZXh0XG4gICAgICAgICAgICAgICAgICAgIH0pXG4gICAgICAgICAgICAgICAgICAgIC5zZXRTZWxlY3Rpb24oc2VsZWN0aW9uKVxuICAgICAgICAgICAgICAgICAgICAuc2Nyb2xsSW50b1ZpZXcoKVxuXG4gICAgICAgICAgICAgICAgICB2aWV3LmRpc3BhdGNoKHRyKVxuXG4gICAgICAgICAgICAgICAgICByZXR1cm4gdHJ1ZVxuICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICByZXR1cm4gZmFsc2UgLy8gV2UgZGlkIG5vdCBoYW5kbGUgdGhpc1xuICAgICAgICAgIH1cbiAgICAgICAgfVxuICAgICAgfSlcbiAgICBdXG4gIH1cbn1cbiJdfQ==