function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

function _possibleConstructorReturn(self, call) { if (call && (typeof call === "object" || typeof call === "function")) { return call; } return _assertThisInitialized(self); }

function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }

function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); if (superClass) _setPrototypeOf(subClass, superClass); }

function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf || function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }

import './styles';
import { Decoration, DecorationSet, EditorView } from 'prosemirror-view';
import { Element } from '@chuspace/editor-base';
import { Plugin } from 'prosemirror-state';

var Placeholder =
/*#__PURE__*/
function (_Element) {
  _inherits(Placeholder, _Element);

  function Placeholder() {
    var _getPrototypeOf2;

    var _this;

    _classCallCheck(this, Placeholder);

    for (var _len = arguments.length, args = new Array(_len), _key = 0; _key < _len; _key++) {
      args[_key] = arguments[_key];
    }

    _this = _possibleConstructorReturn(this, (_getPrototypeOf2 = _getPrototypeOf(Placeholder)).call.apply(_getPrototypeOf2, [this].concat(args)));
    _this.name = 'placeholder';
    _this.options = {
      emptyNodeClass: 'is-empty',
      emptyNodeText: 'Write something...',
      showOnlyWhenEditable: true
    };
    return _this;
  }

  _createClass(Placeholder, [{
    key: "update",
    get: function get() {
      return function (view) {
        view.updateState(view.state);
      };
    }
  }, {
    key: "plugins",
    get: function get() {
      var _this2 = this;

      return [new Plugin({
        props: {
          decorations: function decorations(_ref) {
            var doc = _ref.doc,
                plugins = _ref.plugins;
            var editablePlugin = plugins.find(function (plugin) {
              return plugin.key.startsWith('editable$');
            });
            var editable = editablePlugin.props.editable();
            var active = editable || !_this2.options.showOnlyWhenEditable;

            if (!active) {
              return false;
            }

            var decorations = [];
            var completelyEmpty = doc.textContent === '' && doc.childCount <= 1 && doc.content.size <= 2;
            doc.descendants(function (node, pos) {
              if (!completelyEmpty) {
                return;
              }

              var decoration = Decoration.node(pos, pos + node.nodeSize, {
                "class": _this2.options.emptyNodeClass,
                'data-empty-text': _this2.options.emptyNodeText
              });
              decorations.push(decoration);
            });
            return DecorationSet.create(doc, decorations);
          }
        }
      })];
    }
  }]);

  return Placeholder;
}(Element);

export { Placeholder as default };
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uL2xpYi9wbGFjZWhvbGRlci5qcyJdLCJuYW1lcyI6WyJEZWNvcmF0aW9uIiwiRGVjb3JhdGlvblNldCIsIkVkaXRvclZpZXciLCJFbGVtZW50IiwiUGx1Z2luIiwiUGxhY2Vob2xkZXIiLCJuYW1lIiwib3B0aW9ucyIsImVtcHR5Tm9kZUNsYXNzIiwiZW1wdHlOb2RlVGV4dCIsInNob3dPbmx5V2hlbkVkaXRhYmxlIiwidmlldyIsInVwZGF0ZVN0YXRlIiwic3RhdGUiLCJwcm9wcyIsImRlY29yYXRpb25zIiwiZG9jIiwicGx1Z2lucyIsImVkaXRhYmxlUGx1Z2luIiwiZmluZCIsInBsdWdpbiIsImtleSIsInN0YXJ0c1dpdGgiLCJlZGl0YWJsZSIsImFjdGl2ZSIsImNvbXBsZXRlbHlFbXB0eSIsInRleHRDb250ZW50IiwiY2hpbGRDb3VudCIsImNvbnRlbnQiLCJzaXplIiwiZGVzY2VuZGFudHMiLCJub2RlIiwicG9zIiwiZGVjb3JhdGlvbiIsIm5vZGVTaXplIiwicHVzaCIsImNyZWF0ZSJdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7Ozs7Ozs7OztBQUVBLE9BQU8sVUFBUDtBQUVBLFNBQVNBLFVBQVQsRUFBcUJDLGFBQXJCLEVBQW9DQyxVQUFwQyxRQUFzRCxrQkFBdEQ7QUFFQSxTQUFTQyxPQUFULFFBQXdCLHVCQUF4QjtBQUNBLFNBQVNDLE1BQVQsUUFBdUIsbUJBQXZCOztJQUVxQkMsVzs7Ozs7Ozs7Ozs7Ozs7Ozs7VUFDbkJDLEksR0FBTyxhO1VBRVBDLE8sR0FBVTtBQUNSQyxNQUFBQSxjQUFjLEVBQUUsVUFEUjtBQUVSQyxNQUFBQSxhQUFhLEVBQUUsb0JBRlA7QUFHUkMsTUFBQUEsb0JBQW9CLEVBQUU7QUFIZCxLOzs7Ozs7d0JBTUc7QUFDWCxhQUFPLFVBQUNDLElBQUQsRUFBc0I7QUFDM0JBLFFBQUFBLElBQUksQ0FBQ0MsV0FBTCxDQUFpQkQsSUFBSSxDQUFDRSxLQUF0QjtBQUNELE9BRkQ7QUFHRDs7O3dCQUVhO0FBQUE7O0FBQ1osYUFBTyxDQUNMLElBQUlULE1BQUosQ0FBVztBQUNUVSxRQUFBQSxLQUFLLEVBQUU7QUFDTEMsVUFBQUEsV0FBVyxFQUFFLDJCQUFzQjtBQUFBLGdCQUFuQkMsR0FBbUIsUUFBbkJBLEdBQW1CO0FBQUEsZ0JBQWRDLE9BQWMsUUFBZEEsT0FBYztBQUNqQyxnQkFBTUMsY0FBYyxHQUFHRCxPQUFPLENBQUNFLElBQVIsQ0FBYSxVQUFBQyxNQUFNO0FBQUEscUJBQUlBLE1BQU0sQ0FBQ0MsR0FBUCxDQUFXQyxVQUFYLENBQXNCLFdBQXRCLENBQUo7QUFBQSxhQUFuQixDQUF2QjtBQUNBLGdCQUFNQyxRQUFRLEdBQUdMLGNBQWMsQ0FBQ0osS0FBZixDQUFxQlMsUUFBckIsRUFBakI7QUFDQSxnQkFBTUMsTUFBTSxHQUFHRCxRQUFRLElBQUksQ0FBQyxNQUFJLENBQUNoQixPQUFMLENBQWFHLG9CQUF6Qzs7QUFFQSxnQkFBSSxDQUFDYyxNQUFMLEVBQWE7QUFDWCxxQkFBTyxLQUFQO0FBQ0Q7O0FBRUQsZ0JBQU1ULFdBQVcsR0FBRyxFQUFwQjtBQUNBLGdCQUFNVSxlQUFlLEdBQUdULEdBQUcsQ0FBQ1UsV0FBSixLQUFvQixFQUFwQixJQUEwQlYsR0FBRyxDQUFDVyxVQUFKLElBQWtCLENBQTVDLElBQWlEWCxHQUFHLENBQUNZLE9BQUosQ0FBWUMsSUFBWixJQUFvQixDQUE3RjtBQUVBYixZQUFBQSxHQUFHLENBQUNjLFdBQUosQ0FBZ0IsVUFBQ0MsSUFBRCxFQUFPQyxHQUFQLEVBQWU7QUFDN0Isa0JBQUksQ0FBQ1AsZUFBTCxFQUFzQjtBQUNwQjtBQUNEOztBQUVELGtCQUFNUSxVQUFVLEdBQUdqQyxVQUFVLENBQUMrQixJQUFYLENBQWdCQyxHQUFoQixFQUFxQkEsR0FBRyxHQUFHRCxJQUFJLENBQUNHLFFBQWhDLEVBQTBDO0FBQzNELHlCQUFPLE1BQUksQ0FBQzNCLE9BQUwsQ0FBYUMsY0FEdUM7QUFFM0QsbUNBQW1CLE1BQUksQ0FBQ0QsT0FBTCxDQUFhRTtBQUYyQixlQUExQyxDQUFuQjtBQUlBTSxjQUFBQSxXQUFXLENBQUNvQixJQUFaLENBQWlCRixVQUFqQjtBQUNELGFBVkQ7QUFZQSxtQkFBT2hDLGFBQWEsQ0FBQ21DLE1BQWQsQ0FBcUJwQixHQUFyQixFQUEwQkQsV0FBMUIsQ0FBUDtBQUNEO0FBMUJJO0FBREUsT0FBWCxDQURLLENBQVA7QUFnQ0Q7Ozs7RUFoRHNDWixPOztTQUFwQkUsVyIsInNvdXJjZXNDb250ZW50IjpbIi8vIEBmbG93XG5cbmltcG9ydCAnLi9zdHlsZXMnXG5cbmltcG9ydCB7IERlY29yYXRpb24sIERlY29yYXRpb25TZXQsIEVkaXRvclZpZXcgfSBmcm9tICdwcm9zZW1pcnJvci12aWV3J1xuXG5pbXBvcnQgeyBFbGVtZW50IH0gZnJvbSAnQGNodXNwYWNlL2VkaXRvci1iYXNlJ1xuaW1wb3J0IHsgUGx1Z2luIH0gZnJvbSAncHJvc2VtaXJyb3Itc3RhdGUnXG5cbmV4cG9ydCBkZWZhdWx0IGNsYXNzIFBsYWNlaG9sZGVyIGV4dGVuZHMgRWxlbWVudCB7XG4gIG5hbWUgPSAncGxhY2Vob2xkZXInXG5cbiAgb3B0aW9ucyA9IHtcbiAgICBlbXB0eU5vZGVDbGFzczogJ2lzLWVtcHR5JyxcbiAgICBlbXB0eU5vZGVUZXh0OiAnV3JpdGUgc29tZXRoaW5nLi4uJyxcbiAgICBzaG93T25seVdoZW5FZGl0YWJsZTogdHJ1ZVxuICB9XG5cbiAgZ2V0IHVwZGF0ZSgpIHtcbiAgICByZXR1cm4gKHZpZXc6IEVkaXRvclZpZXcpID0+IHtcbiAgICAgIHZpZXcudXBkYXRlU3RhdGUodmlldy5zdGF0ZSlcbiAgICB9XG4gIH1cblxuICBnZXQgcGx1Z2lucygpIHtcbiAgICByZXR1cm4gW1xuICAgICAgbmV3IFBsdWdpbih7XG4gICAgICAgIHByb3BzOiB7XG4gICAgICAgICAgZGVjb3JhdGlvbnM6ICh7IGRvYywgcGx1Z2lucyB9KSA9PiB7XG4gICAgICAgICAgICBjb25zdCBlZGl0YWJsZVBsdWdpbiA9IHBsdWdpbnMuZmluZChwbHVnaW4gPT4gcGx1Z2luLmtleS5zdGFydHNXaXRoKCdlZGl0YWJsZSQnKSlcbiAgICAgICAgICAgIGNvbnN0IGVkaXRhYmxlID0gZWRpdGFibGVQbHVnaW4ucHJvcHMuZWRpdGFibGUoKVxuICAgICAgICAgICAgY29uc3QgYWN0aXZlID0gZWRpdGFibGUgfHwgIXRoaXMub3B0aW9ucy5zaG93T25seVdoZW5FZGl0YWJsZVxuXG4gICAgICAgICAgICBpZiAoIWFjdGl2ZSkge1xuICAgICAgICAgICAgICByZXR1cm4gZmFsc2VcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgY29uc3QgZGVjb3JhdGlvbnMgPSBbXVxuICAgICAgICAgICAgY29uc3QgY29tcGxldGVseUVtcHR5ID0gZG9jLnRleHRDb250ZW50ID09PSAnJyAmJiBkb2MuY2hpbGRDb3VudCA8PSAxICYmIGRvYy5jb250ZW50LnNpemUgPD0gMlxuXG4gICAgICAgICAgICBkb2MuZGVzY2VuZGFudHMoKG5vZGUsIHBvcykgPT4ge1xuICAgICAgICAgICAgICBpZiAoIWNvbXBsZXRlbHlFbXB0eSkge1xuICAgICAgICAgICAgICAgIHJldHVyblxuICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgY29uc3QgZGVjb3JhdGlvbiA9IERlY29yYXRpb24ubm9kZShwb3MsIHBvcyArIG5vZGUubm9kZVNpemUsIHtcbiAgICAgICAgICAgICAgICBjbGFzczogdGhpcy5vcHRpb25zLmVtcHR5Tm9kZUNsYXNzLFxuICAgICAgICAgICAgICAgICdkYXRhLWVtcHR5LXRleHQnOiB0aGlzLm9wdGlvbnMuZW1wdHlOb2RlVGV4dFxuICAgICAgICAgICAgICB9KVxuICAgICAgICAgICAgICBkZWNvcmF0aW9ucy5wdXNoKGRlY29yYXRpb24pXG4gICAgICAgICAgICB9KVxuXG4gICAgICAgICAgICByZXR1cm4gRGVjb3JhdGlvblNldC5jcmVhdGUoZG9jLCBkZWNvcmF0aW9ucylcbiAgICAgICAgICB9XG4gICAgICAgIH1cbiAgICAgIH0pXG4gICAgXVxuICB9XG59XG4iXX0=