function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

function _possibleConstructorReturn(self, call) { if (call && (typeof call === "object" || typeof call === "function")) { return call; } return _assertThisInitialized(self); }

function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }

function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); if (superClass) _setPrototypeOf(subClass, superClass); }

function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf || function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }

/* global FileReader */
import { EditorState, Plugin, Transaction } from 'prosemirror-state';
import { Node } from '@chuspace/editor-base';
import { Node as PMNode } from 'prosemirror-model';

var Image =
/*#__PURE__*/
function (_Node) {
  _inherits(Image, _Node);

  function Image() {
    var _getPrototypeOf2;

    var _this;

    _classCallCheck(this, Image);

    for (var _len = arguments.length, args = new Array(_len), _key = 0; _key < _len; _key++) {
      args[_key] = arguments[_key];
    }

    _this = _possibleConstructorReturn(this, (_getPrototypeOf2 = _getPrototypeOf(Image)).call.apply(_getPrototypeOf2, [this].concat(args)));
    _this.name = 'image';
    return _this;
  }

  _createClass(Image, [{
    key: "commands",
    value: function commands(_ref) {
      var type = _ref.type;
      return function (attrs) {
        return function (state, dispatch) {
          var selection = state.selection;
          var position = selection.$cursor ? selection.$cursor.pos : selection.$to.pos;
          var node = type.create(attrs);
          var transaction = state.tr.insert(position, node);
          dispatch(transaction);
        };
      };
    }
  }, {
    key: "schema",
    get: function get() {
      return {
        inline: true,
        attrs: {
          src: {},
          alt: {
            "default": null
          },
          title: {
            "default": null
          }
        },
        group: 'inline',
        draggable: true,
        parseDOM: [{
          tag: 'img[src]',
          getAttrs: function getAttrs(dom) {
            return {
              src: dom.getAttribute('src'),
              title: dom.getAttribute('title'),
              alt: dom.getAttribute('alt')
            };
          }
        }],
        toDOM: function toDOM(node) {
          return ['img', node.attrs];
        }
      };
    }
  }, {
    key: "plugins",
    get: function get() {
      return [new Plugin({
        props: {
          handleDOMEvents: {
            drop: function drop(view, event) {
              var hasFiles = event.dataTransfer && event.dataTransfer.files && event.dataTransfer.files.length;

              if (!hasFiles) {
                return;
              }

              var images = Array.from(event.dataTransfer.files).filter(function (file) {
                return /image/i.test(file.type);
              });

              if (images.length === 0) {
                return;
              }

              event.preventDefault();
              var schema = view.state.schema;
              var coordinates = view.posAtCoords({
                left: event.clientX,
                top: event.clientY
              });
              images.forEach(function (image) {
                var reader = new FileReader();

                reader.onload = function (readerEvent) {
                  var node = schema.nodes.image.create({
                    src: readerEvent.target.result
                  });
                  var transaction = view.state.tr.insert(coordinates.pos, node);
                  view.dispatch(transaction);
                };

                reader.readAsDataURL(image);
              });
            }
          }
        }
      })];
    }
  }]);

  return Image;
}(Node);

export { Image as default };
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uL2xpYi9ub2Rlcy9pbWFnZS5qcyJdLCJuYW1lcyI6WyJFZGl0b3JTdGF0ZSIsIlBsdWdpbiIsIlRyYW5zYWN0aW9uIiwiTm9kZSIsIlBNTm9kZSIsIkltYWdlIiwibmFtZSIsInR5cGUiLCJhdHRycyIsInN0YXRlIiwiZGlzcGF0Y2giLCJzZWxlY3Rpb24iLCJwb3NpdGlvbiIsIiRjdXJzb3IiLCJwb3MiLCIkdG8iLCJub2RlIiwiY3JlYXRlIiwidHJhbnNhY3Rpb24iLCJ0ciIsImluc2VydCIsImlubGluZSIsInNyYyIsImFsdCIsInRpdGxlIiwiZ3JvdXAiLCJkcmFnZ2FibGUiLCJwYXJzZURPTSIsInRhZyIsImdldEF0dHJzIiwiZG9tIiwiZ2V0QXR0cmlidXRlIiwidG9ET00iLCJwcm9wcyIsImhhbmRsZURPTUV2ZW50cyIsImRyb3AiLCJ2aWV3IiwiZXZlbnQiLCJoYXNGaWxlcyIsImRhdGFUcmFuc2ZlciIsImZpbGVzIiwibGVuZ3RoIiwiaW1hZ2VzIiwiQXJyYXkiLCJmcm9tIiwiZmlsdGVyIiwiZmlsZSIsInRlc3QiLCJwcmV2ZW50RGVmYXVsdCIsInNjaGVtYSIsImNvb3JkaW5hdGVzIiwicG9zQXRDb29yZHMiLCJsZWZ0IiwiY2xpZW50WCIsInRvcCIsImNsaWVudFkiLCJmb3JFYWNoIiwiaW1hZ2UiLCJyZWFkZXIiLCJGaWxlUmVhZGVyIiwib25sb2FkIiwicmVhZGVyRXZlbnQiLCJub2RlcyIsInRhcmdldCIsInJlc3VsdCIsInJlYWRBc0RhdGFVUkwiXSwibWFwcGluZ3MiOiI7Ozs7Ozs7Ozs7Ozs7Ozs7QUFFQTtBQUVBLFNBQVNBLFdBQVQsRUFBc0JDLE1BQXRCLEVBQThCQyxXQUE5QixRQUFpRCxtQkFBakQ7QUFFQSxTQUFTQyxJQUFULFFBQXFCLHVCQUFyQjtBQUNBLFNBQVNBLElBQUksSUFBSUMsTUFBakIsUUFBK0IsbUJBQS9COztJQUVxQkMsSzs7Ozs7Ozs7Ozs7Ozs7Ozs7VUFDbkJDLEksR0FBTyxPOzs7Ozs7bUNBOEJv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QUcsRUFBRWpCLEtBQUssQ0FBQ2tCO0FBRndCLGVBQWpCLENBQXBCO0FBS0FiLGNBQUFBLE1BQU0sQ0FBQ2MsT0FBUCxDQUFlLFVBQUFDLEtBQUssRUFBSTtBQUN0QixvQkFBTUMsTUFBTSxHQUFHLElBQUlDLFVBQUosRUFBZjs7QUFFQUQsZ0JBQUFBLE1BQU0sQ0FBQ0UsTUFBUCxHQUFnQixVQUFBQyxXQUFXLEVBQUk7QUFDN0Isc0JBQU03QyxJQUFJLEdBQUdpQyxNQUFNLENBQUNhLEtBQVAsQ0FBYUwsS0FBYixDQUFtQnhDLE1BQW5CLENBQTBCO0FBQ3JDSyxvQkFBQUEsR0FBRyxFQUFFdUMsV0FBVyxDQUFDRSxNQUFaLENBQW1CQztBQURhLG1CQUExQixDQUFiO0FBR0Esc0JBQU05QyxXQUFXLEdBQUdrQixJQUFJLENBQUMzQixLQUFMLENBQVdVLEVBQVgsQ0FBY0MsTUFBZCxDQUFxQjhCLFdBQVcsQ0FBQ3BDLEdBQWpDLEVBQXNDRSxJQUF0QyxDQUFwQjtBQUNBb0Isa0JBQUFBLElBQUksQ0FBQzFCLFFBQUwsQ0FBY1EsV0FBZDtBQUNELGlCQU5EOztBQU9Bd0MsZ0JBQUFBLE1BQU0sQ0FBQ08sYUFBUCxDQUFxQlIsS0FBckI7QUFDRCxlQVhEO0FBWUQ7QUFsQ2M7QUFEWjtBQURFLE9BQVgsQ0FESyxDQUFQO0FBMENEOzs7O0VBcEZnQ3RELEk7O1NBQWRFLEsiLCJzb3VyY2VzQ29udGVudCI6WyIvLyBAZmxvd1xuXG4vKiBnbG9iYWwgRmlsZVJlYWRlciAqL1xuXG5pbXBvcnQgeyBFZGl0b3JTdGF0ZSwgUGx1Z2luLCBUcmFuc2FjdGlvbiB9IGZyb20gJ3Byb3NlbWlycm9yLXN0YXRlJ1xuXG5pbXBvcnQgeyBOb2RlIH0gZnJvbSAnQGNodXNwYWNlL2VkaXRvci1iYXNlJ1xuaW1wb3J0IHsgTm9kZSBhcyBQTU5vZGUgfSBmcm9tICdwcm9zZW1pcnJvci1tb2RlbCdcblxuZXhwb3J0IGRlZmF1bHQgY2xhc3MgSW1hZ2UgZXh0ZW5kcyBOb2RlIHtcbiAgbmFtZSA9ICdpbWFnZSdcblxuICBnZXQgc2NoZW1hKCkge1xuICAgIHJldHVybiB7XG4gICAgICBpbmxpbmU6IHRydWUsXG4gICAgICBhdHRyczoge1xuICAgICAgICBzcmM6IHt9LFxuICAgICAgICBhbHQ6IHtcbiAgICAgICAgICBkZWZhdWx0OiBudWxsXG4gICAgICAgIH0sXG4gICAgICAgIHRpdGxlOiB7XG4gICAgICAgICAgZGVmYXVsdDogbnVsbFxuICAgICAgICB9XG4gICAgICB9LFxuICAgICAgZ3JvdXA6ICdpbmxpbmUnLFxuICAgICAgZHJhZ2dhYmxlOiB0cnVlLFxuICAgICAgcGFyc2VET006IFtcbiAgICAgICAge1xuICAgICAgICAgIHRhZzogJ2ltZ1tzcmNdJyxcbiAgICAgICAgICBnZXRBdHRyczogKGRvbTogUE1Ob2RlKSA9PiAoe1xuICAgICAgICAgICAgc3JjOiBkb20uZ2V0QXR0cmlidXRlKCdzcmMnKSxcbiAgICAgICAgICAgIHRpdGxlOiBkb20uZ2V0QXR0cmlidXRlKCd0aXRsZScpLFxuICAgICAgICAgICAgYWx0OiBkb20uZ2V0QXR0cmlidXRlKCdhbHQnKVxuICAgICAgICAgIH0pXG4gICAgICAgIH1cbiAgICAgIF0sXG4gICAgICB0b0RPTTogKG5vZGU6IFBNTm9kZSkgPT4gWydpbWcnLCBub2RlLmF0dHJzXVxuICAgIH1cbiAgfVxuXG4gIGNvbW1hbmRzKHsgdHlwZSB9OiBQTU5vZGUpIHtcbiAgICByZXR1cm4gKGF0dHJzOiB7fSkgPT4gKHN0YXRlOiBFZGl0b3JTdGF0ZSwgZGlzcGF0Y2g6IFRyYW5zYWN0aW9uKSA9PiB7XG4gICAgICBjb25zdCB7IHNlbGVjdGlvbiB9ID0gc3RhdGVcbiAgICAgIGNvbnN0IHBvc2l0aW9uID0gc2VsZWN0aW9uLiRjdXJzb3IgPyBzZWxlY3Rpb24uJGN1cnNvci5wb3MgOiBzZWxlY3Rpb24uJHRvLnBvc1xuICAgICAgY29uc3Qgbm9kZSA9IHR5cGUuY3JlYXRlKGF0dHJzKVxuICAgICAgY29uc3QgdHJhbnNhY3Rpb24gPSBzdGF0ZS50ci5pbnNlcnQocG9zaXRpb24sIG5vZGUpXG4gICAgICBkaXNwYXRjaCh0cmFuc2FjdGlvbilcbiAgICB9XG4gIH1cblxuICBnZXQgcGx1Z2lucygpIHtcbiAgICByZXR1cm4gW1xuICAgICAgbmV3IFBsdWdpbih7XG4gICAgICAgIHByb3BzOiB7XG4gICAgICAgICAgaGFuZGxlRE9NRXZlbnRzOiB7XG4gICAgICAgICAgICBkcm9wKHZpZXcsIGV2ZW50KSB7XG4gICAgICAgICAgICAgIGNvbnN0IGhhc0ZpbGVzID0gZXZlbnQuZGF0YVRyYW5zZmVyICYmIGV2ZW50LmRhdGFUcmFuc2Zlci5maWxlcyAmJiBldmVudC5kYXRhVHJhbnNmZXIuZmlsZXMubGVuZ3RoXG5cbiAgICAgICAgICAgICAgaWYgKCFoYXNGaWxlcykge1xuICAgICAgICAgICAgICAgIHJldHVyblxuICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgY29uc3QgaW1hZ2VzID0gQXJyYXkuZnJvbShldmVudC5kYXRhVHJhbnNmZXIuZmlsZXMpLmZpbHRlcihmaWxlID0+IC9pbWFnZS9pLnRlc3QoZmlsZS50eXBlKSlcblxuICAgICAgICAgICAgICBpZiAoaW1hZ2VzLmxlbmd0aCA9PT0gMCkge1xuICAgICAgICAgICAgICAgIHJldHVyblxuICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgZXZlbnQucHJldmVudERlZmF1bHQoKVxuXG4gICAgICAgICAgICAgIGNvbnN0IHsgc2NoZW1hIH0gPSB2aWV3LnN0YXRlXG4gICAgICAgICAgICAgIGNvbnN0IGNvb3JkaW5hdGVzID0gdmlldy5wb3NBdENvb3Jkcyh7XG4gICAgICAgICAgICAgICAgbGVmdDogZXZlbnQuY2xpZW50WCxcbiAgICAgICAgICAgICAgICB0b3A6IGV2ZW50LmNsaWVudFlcbiAgICAgICAgICAgICAgfSlcblxuICAgICAgICAgICAgICBpbWFnZXMuZm9yRWFjaChpbWFnZSA9PiB7XG4gICAgICAgICAgICAgICAgY29uc3QgcmVhZGVyID0gbmV3IEZpbGVSZWFkZXIoKVxuXG4gICAgICAgICAgICAgICAgcmVhZGVyLm9ubG9hZCA9IHJlYWRlckV2ZW50ID0+IHtcbiAgICAgICAgICAgICAgICAgIGNvbnN0IG5vZGUgPSBzY2hlbWEubm9kZXMuaW1hZ2UuY3JlYXRlKHtcbiAgICAgICAgICAgICAgICAgICAgc3JjOiByZWFkZXJFdmVudC50YXJnZXQucmVzdWx0XG4gICAgICAgICAgICAgICAgICB9KVxuICAgICAgICAgICAgICAgICAgY29uc3QgdHJhbnNhY3Rpb24gPSB2aWV3LnN0YXRlLnRyLmluc2VydChjb29yZGluYXRlcy5wb3MsIG5vZGUpXG4gICAgICAgICAgICAgICAgICB2aWV3LmRpc3BhdGNoKHRyYW5zYWN0aW9uKVxuICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICByZWFkZXIucmVhZEFzRGF0YVVSTChpbWFnZSlcbiAgICAgICAgICAgICAgfSlcbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9XG4gICAgICAgIH1cbiAgICAgIH0pXG4gICAgXVxuICB9XG59XG4iXX0=