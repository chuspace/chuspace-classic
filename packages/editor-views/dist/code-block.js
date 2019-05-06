function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (call && (typeof call === "object" || typeof call === "function")) { return call; } return _assertThisInitialized(self); }

function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }

function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); if (superClass) _setPrototypeOf(subClass, superClass); }

function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf || function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }

import { Node as ProsemirrorNode, Schema } from 'prosemirror-model';
import { Selection, TextSelection } from 'prosemirror-state';
import { redo, undo } from 'prosemirror-history';
import BaseView from './base';
import CodeMirror from 'codemirror';
import { DEFAULT_MODE } from '@chuspace/code-editor-modes';
import { EditorView } from 'prosemirror-view';
import { exitCode } from 'prosemirror-commands';

var CodeBlockView =
/*#__PURE__*/
function (_BaseView) {
  _inherits(CodeBlockView, _BaseView);

  function CodeBlockView(props) {
    var _this;

    _classCallCheck(this, CodeBlockView);

    // Call super but don't render the view
    _this = _possibleConstructorReturn(this, _getPrototypeOf(CodeBlockView).call(this, props, false)); // Custom attrs for code block node view

    _this.cm = null;
    _this.updating = false;
    _this.mode = DEFAULT_MODE;
    _this.content = void 0;
    _this.incomingChanges = false;
    _this.getCMInstance = void 0;
    _this.handleLanguageChange = void 0;

    _this.getCMInstance = function (instance) {
      return _this.cm = instance;
    };

    _this.handleLanguageChange = function () {
      var mode = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : _this.mode;
      return _this.node.attrs.language = mode;
    };

    _this.forwardSelection = function () {
      if (!_this.cm.hasFocus()) return;
      var state = _this.view.state;

      var selection = _this.asProseMirrorSelection(state.doc);

      if (!selection.eq(state.selection)) {
        _this.view.dispatch(state.tr.setSelection(selection));
      }
    };

    _this.valueChanged = function () {
      var change = computeChange(_this.node.textContent, _this.cm.getValue());

      if (change) {
        var start = _this.getPos() + 1;

        var tr = _this.view.state.tr.replaceWith(start + change.from, start + change.to, change.text ? _this.schema.text(change.text) : null);

        _this.view.dispatch(tr);
      }
    };

    _this.asProseMirrorSelection = function (doc) {
      var offset = _this.getPos() + 1;
      var anchor = _this.cm.indexFromPos(_this.cm.getCursor('anchor')) + offset;
      var head = _this.cm.indexFromPos(_this.cm.getCursor('head')) + offset;
      return TextSelection.create(doc, anchor, head);
    };

    _this.setSelection = function (anchor, head) {
      _this.cm.focus();

      _this.updating = true;

      _this.cm.setSelection(_this.cm.posFromIndex(anchor), _this.cm.posFromIndex(head));

      _this.updating = false;
    };

    _this.codeMirrorKeymap = function () {
      var _CodeMirror$normalize;

      var view = _this.view;
      var mod = /Mac/.test(navigator.platform) ? 'Cmd' : 'Ctrl';
      return CodeMirror.normalizeKeyMap((_CodeMirror$normalize = {
        Up: function Up() {
          return _this.maybeEscape('line', -1);
        },
        Left: function Left() {
          return _this.maybeEscape('char', -1);
        },
        Down: function Down() {
          return _this.maybeEscape('line', 1);
        },
        Right: function Right() {
          return _this.maybeEscape('char', 1);
        }
      }, _defineProperty(_CodeMirror$normalize, "".concat(mod, "-Z"), function Z() {
        return undo(view.state, view.dispatch);
      }), _defineProperty(_CodeMirror$normalize, "Shift-".concat(mod, "-Z"), function ShiftZ() {
        return redo(view.state, view.dispatch);
      }), _defineProperty(_CodeMirror$normalize, "".concat(mod, "-Y"), function Y() {
        return redo(view.state, view.dispatch);
      }), _defineProperty(_CodeMirror$normalize, 'Ctrl-Enter', function CtrlEnter() {
        if (exitCode(view.state, view.dispatch)) view.focus();
      }), _CodeMirror$normalize));
    };

    _this.maybeEscape = function (unit, dir) {
      var pos = _this.cm.getCursor();

      if (_this.cm.somethingSelected() || pos.line !== (dir < 0 ? _this.cm.firstLine() : _this.cm.lastLine()) || unit === 'char' && pos.ch !== (dir < 0 ? 0 : _this.cm.getLine(pos.line).length)) {
        return CodeMirror.Pass;
      }

      _this.view.focus();

      var targetPos = _this.getPos() + (dir < 0 ? 0 : _this.node.nodeSize);
      var selection = Selection.near(_this.view.state.doc.resolve(targetPos), dir);

      _this.view.dispatch(_this.view.state.tr.setSelection(selection).scrollIntoView());

      _this.view.focus();
    };

    _this.update = function (node) {
      if (node.type !== _this.node.type) return false;
      _this.node = node;
      var change = computeChange(_this.cm.getValue(), node.textContent);

      if (change) {
        _this.updating = true;

        _this.cm.replaceRange(change.text, _this.cm.posFromIndex(change.from), _this.cm.posFromIndex(change.to));

        _this.updating = false;
      }

      return true;
    };

    _this.selectNode = function () {
      _this.cm.focus();
    };

    _this.destroy = function () {
      _this.containerNode.remove();

      _this.view.focus();
    };

    _this.mode = _this.node.attrs.language;
    _this.content = _this.node.textContent; // Renders view component

    _this.renderElement(); // CodeMirror needs to be in the DOM to properly initialize, so
    // schedule it to update itself


    setTimeout(function () {
      return _this.cm.refresh();
    }, 20); // Propagate updates from the code editor to ProseMirror

    _this.cm.on('beforeChange', function () {
      return _this.incomingChanges = true;
    }); // Propagate updates from the code editor to ProseMirror


    _this.cm.on('cursorActivity', function () {
      if (!_this.updating && !_this.incomingChanges) _this.forwardSelection();
    });

    _this.cm.on('changes', function () {
      if (!_this.updating) {
        _this.valueChanged();

        _this.forwardSelection();
      }

      _this.incomingChanges = false;
    });

    _this.cm.on('focus', function () {
      return _this.forwardSelection();
    });

    return _this;
  }
  /* Component calls to set cm instance after render */


  return CodeBlockView;
}(BaseView);

export { CodeBlockView as default };

function computeChange(oldVal, newVal) {
  if (oldVal === newVal) return null;
  var start = 0;
  var oldEnd = oldVal.length;
  var newEnd = newVal.length;

  while (start < oldEnd && oldVal.charCodeAt(start) === newVal.charCodeAt(start)) {
    ++start;
  }

  while (oldEnd > start && newEnd > start && oldVal.charCodeAt(oldEnd - 1) === newVal.charCodeAt(newEnd - 1)) {
    oldEnd--;
    newEnd--;
  }

  return {
    from: start,
    to: oldEnd,
    text: newVal.slice(start, newEnd)
  };
}
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uL2xpYi9jb2RlLWJsb2NrLmpzIl0sIm5hbWVzIjpbIk5vZGUiLCJQcm9zZW1pcnJvck5vZGUiLCJTY2hlbWEiLCJTZWxlY3Rpb24iLCJUZXh0U2VsZWN0aW9uIiwicmVkbyIsInVuZG8iLCJCYXNlVmlldyIsIkNvZGVNaXJyb3IiLCJERUZBVUxUX01PREUiLCJFZGl0b3JWaWV3IiwiZXhpdENvZGUiLCJDb2RlQmxvY2tWaWV3IiwicHJvcHMiLCJjbSIsInVwZGF0aW5nIiwibW9kZSIsImNvbnRlbnQiLCJpbmNvbWluZ0NoYW5nZXMiLCJnZXRDTUluc3RhbmNlIiwiaGFuZGxlTGFuZ3VhZ2VDaGFuZ2UiLCJpbnN0YW5jZSIsIm5vZGUiLCJhdHRycyIsImxhbmd1YWdlIiwiZm9yd2FyZFNlbGVjdGlvbiIsImhhc0ZvY3VzIiwic3RhdGUiLCJ2aWV3Iiwic2VsZWN0aW9uIiwiYXNQcm9zZU1pcnJvclNlbGVjdGlvbiIsImRvYyIsImVxIiwiZGlzcGF0Y2giLCJ0ciIsInNldFNlbGVjdGlvbiIsInZhbHVlQ2hhbmdlZCIsImNoYW5nZSIsImNvbXB1dGVDaGFuZ2UiLCJ0ZXh0Q29udGVudCIsImdldFZhbHVlIiwic3RhcnQiLCJnZXRQb3MiLCJyZXBsYWNlV2l0aCIsImZyb20iLCJ0byIsInRleHQiLCJzY2hlbWEiLCJvZmZzZXQiLCJhbmNob3IiLCJpbmRleEZyb21Qb3MiLCJnZXRDdXJzb3IiLCJoZWFkIiwiY3JlYXRlIiwiZm9jdXMiLCJwb3NGcm9tSW5kZXgiLCJjb2RlTWlycm9yS2V5bWFwIiwibW9kIiwidGVzdCIsIm5hdmlnYXRvciIsInBsYXRmb3JtIiwibm9ybWFsaXplS2V5TWFwIiwiVXAiLCJtYXliZUVzY2FwZSIsIkxlZnQiLCJEb3duIiwiUmlnaHQiLCJ1bml0IiwiZGlyIiwicG9zIiwic29tZXRoaW5nU2VsZWN0ZWQiLCJsaW5lIiwiZmlyc3RMaW5lIiwibGFzdExpbmUiLCJjaCIsImdldExpbmUiLCJsZW5ndGgiLCJQYXNzIiwidGFyZ2V0UG9zIiwibm9kZVNpemUiLCJuZWFyIiwicmVzb2x2ZSIsInNjcm9sbEludG9WaWV3IiwidXBkYXRlIiwidHlwZSIsInJlcGxhY2VSYW5nZSIsInNlbGVjdE5vZGUiLCJkZXN0cm95IiwiY29udGFpbmVyTm9kZSIsInJlbW92ZSIsInJlbmRlckVsZW1lbnQiLCJzZXRUaW1lb3V0IiwicmVmcmVzaCIsIm9uIiwib2xkVmFsIiwibmV3VmFsIiwib2xkRW5kIiwibmV3RW5kIiwiY2hhckNvZGVBdCIsInNsaWNlIl0sIm1hcHBpbmdzIjoiOzs7Ozs7Ozs7Ozs7OztBQUVBLFNBQVNBLElBQUksSUFBSUMsZUFBakIsRUFBa0NDLE1BQWxDLFFBQWdELG1CQUFoRDtBQUNBLFNBQVNDLFNBQVQsRUFBb0JDLGFBQXBCLFFBQXlDLG1CQUF6QztBQUNBLFNBQVNDLElBQVQsRUFBZUMsSUFBZixRQUEyQixxQkFBM0I7QUFFQSxPQUFPQyxRQUFQLE1BQXFCLFFBQXJCO0FBRUEsT0FBT0MsVUFBUCxNQUF1QixZQUF2QjtBQUNBLFNBQVNDLFlBQVQsUUFBNkIsNkJBQTdCO0FBQ0EsU0FBU0MsVUFBVCxRQUEyQixrQkFBM0I7QUFDQSxTQUFTQyxRQUFULFFBQXlCLHNCQUF6Qjs7SUFFcUJDLGE7Ozs7O0FBU25CLHlCQUFZQyxLQUFaLEVBQXFDO0FBQUE7O0FBQUE7O0FBQ25DO0FBQ0EsdUZBQU1BLEtBQU4sRUFBYSxLQUFiLEdBRm1DLENBSW5DOztBQUptQyxVQVJyQ0MsRUFRcUMsR0FSSixJQVFJO0FBQUEsVUFQckNDLFFBT3FDLEdBUGpCLEtBT2lCO0FBQUEsVUFOckNDLElBTXFDLEdBTnRCUCxZQU1zQjtBQUFBLFVBTHJDUSxPQUtxQztBQUFBLFVBSnJDQyxlQUlxQyxHQUpWLEtBSVU7QUFBQSxVQUhyQ0MsYUFHcUM7QUFBQSxVQUZyQ0Msb0JBRXFDOztBQUFBLFVBbUNyQ0QsYUFuQ3FDLEdBbUNyQixVQUFDRSxRQUFEO0FBQUEsYUFBMkIsTUFBS1AsRUFBTCxHQUFVTyxRQUFyQztBQUFBLEtBbkNxQjs7QUFBQSxVQXND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Q0FBa0JGLE1BQU0sR0FBRyxDQUEzQixNQUFrQ0QsTUFBTSxDQUFDRyxVQUFQLENBQWtCRCxNQUFNLEdBQUcsQ0FBM0IsQ0FBN0UsRUFBNEc7QUFDMUdELElBQUFBLE1BQU07QUFDTkMsSUFBQUEsTUFBTTtBQUNQOztBQUNELFNBQU87QUFBRXJELElBQUFBLElBQUksRUFBRUgsS0FBUjtBQUFlSSxJQUFBQSxFQUFFLEVBQUVtRCxNQUFuQjtBQUEyQmxELElBQUFBLElBQUksRUFBRWlELE1BQU0sQ0FBQ0ksS0FBUCxDQUFhMUQsS0FBYixFQUFvQndELE1BQXBCO0FBQWpDLEdBQVA7QUFDRCIsInNvdXJjZXNDb250ZW50IjpbIi8vIEBmbG93XG5cbmltcG9ydCB7IE5vZGUgYXMgUHJvc2VtaXJyb3JOb2RlLCBTY2hlbWEgfSBmcm9tICdwcm9zZW1pcnJvci1tb2RlbCdcbmltcG9ydCB7IFNlbGVjdGlvbiwgVGV4dFNlbGVjdGlvbiB9IGZyb20gJ3Byb3NlbWlycm9yLXN0YXRlJ1xuaW1wb3J0IHsgcmVkbywgdW5kbyB9IGZyb20gJ3Byb3NlbWlycm9yLWhpc3RvcnknXG5cbmltcG9ydCBCYXNlVmlldyBmcm9tICcuL2Jhc2UnXG5pbXBvcnQgdHlwZSB7IEJhc2VWaWV3UHJvcFR5cGUgfSBmcm9tICcuL2Jhc2UnXG5pbXBvcnQgQ29kZU1pcnJvciBmcm9tICdjb2RlbWlycm9yJ1xuaW1wb3J0IHsgREVGQVVMVF9NT0RFIH0gZnJvbSAnQGNodXNwYWNlL2NvZGUtZWRpdG9yLW1vZGVzJ1xuaW1wb3J0IHsgRWRpdG9yVmlldyB9IGZyb20gJ3Byb3NlbWlycm9yLXZpZXcnXG5pbXBvcnQgeyBleGl0Q29kZSB9IGZyb20gJ3Byb3NlbWlycm9yLWNvbW1hbmRzJ1xuXG5leHBvcnQgZGVmYXVsdCBjbGFzcyBDb2RlQmxvY2tWaWV3IGV4dGVuZHMgQmFzZVZpZXcge1xuICBjbTogdHlwZW9mIENvZGVNaXJyb3IuZGVmYXVsdHMgPSBudWxsXG4gIHVwZGF0aW5nOiBib29sZWFuID0gZmFsc2VcbiAgbW9kZTogc3RyaW5nID0gREVGQVVMVF9NT0RFXG4gIGNvbnRlbnQ6IHN0cmluZ1xuICBpbmNvbWluZ0NoYW5nZXM6IGJvb2xlYW4gPSBmYWxzZVxuICBnZXRDTUluc3RhbmNlOiAoKSA9PiBDb2RlTWlycm9yXG4gIGhhbmRsZUxhbmd1YWdlQ2hhbmdlOiAobW9kZTogc3RyaW5nKSA9PiB2b2lkXG5cbiAgY29uc3RydWN0b3IocHJvcHM6IEJhc2VWaWV3UHJvcFR5cGUpIHtcbiAgICAvLyBDYWxsIHN1cGVyIGJ1dCBkb24ndCByZW5kZXIgdGhlIHZpZXdcbiAgICBzdXBlcihwcm9wcywgZmFsc2UpXG5cbiAgICAvLyBDdXN0b20gYXR0cnMgZm9yIGNvZGUgYmxvY2sgbm9kZSB2aWV3XG4gICAgdGhpcy5tb2RlID0gdGhpcy5ub2RlLmF0dHJzLmxhbmd1YWdlXG4gICAgdGhpcy5jb250ZW50ID0gdGhpcy5ub2RlLnRleHRDb250ZW50XG5cbiAgICAvLyBSZW5kZXJzIHZpZXcgY29tcG9uZW50XG4gICAgdGhpcy5yZW5kZXJFbGVtZW50KClcblxuICAgIC8vIENvZGVNaXJyb3IgbmVlZHMgdG8gYmUgaW4gdGhlIERPTSB0byBwcm9wZXJseSBpbml0aWFsaXplLCBzb1xuICAgIC8vIHNjaGVkdWxlIGl0IHRvIHVwZGF0ZSBpdHNlbGZcbiAgICBzZXRUaW1lb3V0KCgpID0+IHRoaXMuY20ucmVmcmVzaCgpLCAyMClcblxuICAgIC8vIFByb3BhZ2F0ZSB1cGRhdGVzIGZyb20gdGhlIGNvZGUgZWRpdG9yIHRvIFByb3NlTWlycm9yXG4gICAgdGhpcy5jbS5vbignYmVmb3JlQ2hhbmdlJywgKCkgPT4gKHRoaXMuaW5jb21pbmdDaGFuZ2VzID0gdHJ1ZSkpXG4gICAgLy8gUHJvcGFnYXRlIHVwZGF0ZXMgZnJvbSB0aGUgY29kZSBlZGl0b3IgdG8gUHJvc2VNaXJyb3JcbiAgICB0aGlzLmNtLm9uKCdjdXJzb3JBY3Rpdml0eScsICgpID0+IHtcbiAgICAgIGlmICghdGhpcy51cGRhdGluZyAmJiAhdGhpcy5pbmNvbWluZ0NoYW5nZXMpIHRoaXMuZm9yd2FyZFNlbGVjdGlvbigpXG4gICAgfSlcblxuICAgIHRoaXMuY20ub24oJ2NoYW5nZXMnLCAoKSA9PiB7XG4gICAgICBpZiAoIXRoaXMudXBkYXRpbmcpIHtcbiAgICAgICAgdGhpcy52YWx1ZUNoYW5nZWQoKVxuICAgICAgICB0aGlzLmZvcndhcmRTZWxlY3Rpb24oKVxuICAgICAgfVxuXG4gICAgICB0aGlzLmluY29taW5nQ2hhbmdlcyA9IGZhbHNlXG4gICAgfSlcblxuICAgIHRoaXMuY20ub24oJ2ZvY3VzJywgKCkgPT4gdGhpcy5mb3J3YXJkU2VsZWN0aW9uKCkpXG4gIH1cblxuICAvKiBDb21wb25lbnQgY2FsbHMgdG8gc2V0IGNtIGluc3RhbmNlIGFmdGVyIHJlbmRlciAqL1xuICBnZXRDTUluc3RhbmNlID0gKGluc3RhbmNlOiBDb2RlTWlycm9yKSA9PiAodGhpcy5jbSA9IGluc3RhbmNlKVxuXG4gIC8qIENvbXBvbmVudCBjYWxscyB0byBzZXQgY20gaW5zdGFuY2UgbW9kZSBhbmQgbm9kZSBhdHRycyAqL1xuICBoYW5kbGVMYW5ndWFnZUNoYW5nZSA9IChtb2RlOiBzdHJpbmcgPSB0aGlzLm1vZGUpID0+ICh0aGlzLm5vZGUuYXR0cnMubGFuZ3VhZ2UgPSBtb2RlKVxuXG4gIC8qKlxuICAgKiB3aGVuIHRoZSBjb2RlIGVkaXRvciBpcyBmb2N1c2VkLHdlIGNhbiBrZWVwIHRoZSBzZWxlY3Rpb24gb2ZcbiAgICogdGhlIG91dGVyIGVkaXRvciBzeW5jaHJvbml6ZWQgd2l0aCB0aGUgaW5uZXIgb25lLHNvIHRoYXQgYW55XG4gICAqIGNvbW1hbmRzIGV4ZWN1dGVkIG9uIHRoZSBvdXRlciBlZGl0b3Igc2VlIGFuIGFjY3VyYXRlIHNlbGVjdGlvblxuICAgKi9cbiAgZm9yd2FyZFNlbGVjdGlvbiA9ICgpID0+IHtcbiAgICBpZiAoIXRoaXMuY20uaGFzRm9jdXMoKSkgcmV0dXJuXG4gICAgbGV0IHN0YXRlID0gdGhpcy52aWV3LnN0YXRlXG4gICAgbGV0IHNlbGVjdGlvbiA9IHRoaXMuYXNQcm9zZU1pcnJvclNlbGVjdGlvbihzdGF0ZS5kb2MpXG4gICAgaWYgKCFzZWxlY3Rpb24uZXEoc3RhdGUuc2VsZWN0aW9uKSkge1xuICAgICAgdGhpcy52aWV3LmRpc3BhdGNoKHN0YXRlLnRyLnNldFNlbGVjdGlvbihzZWxlY3Rpb24pKVxuICAgIH1cbiAgfVxuXG4gIC8qKlxuICAgKiB3aGVuIHRoZSBhY3R1YWwgY29udGVudCBvZiB0aGUgY29kZSBlZGl0b3IgaXMgY2hhbmdlZCx0aGUgZXZlbnQgaGFuZGxlclxuICAgKiByZWdpc3RlcmVkIGluIHRoZSBub2RlIHZpZXcncyBjb25zdHJ1Y3RvciBjYWxscyB0aGlzIG1ldGhvZC5pdCdsbCBjb21wYXJlXG4gICAqIHRoZSBjb2RlIGJsb2NrIG5vZGUncyBjdXJyZW50IHZhbHVlIHRvIHRoZSB2YWx1ZSBpbiB0aGUgZWRpdG9yLGFuZCBkaXNwYXRjaFxuICAgKiBhIHRyYW5zYWN0aW9uIGlmIHRoZXJlIGlzIGEgZGlmZmVyZW5jZS5cbiAgICovXG4gIHZhbHVlQ2hhbmdlZCA9ICgpOiB2b2lkID0+IHtcbiAgICBsZXQgY2hhbmdlID0gY29tcHV0ZUNoYW5nZSh0aGlzLm5vZGUudGV4dENvbnRlbnQsIHRoaXMuY20uZ2V0VmFsdWUoKSlcblxuICAgIGlmIChjaGFuZ2UpIHtcbiAgICAgIGxldCBzdGFydCA9IHRoaXMuZ2V0UG9zKCkgKyAxXG4gICAgICBsZXQgdHIgPSB0aGlzLnZpZXcuc3RhdGUudHIucmVwbGFjZVdpdGgoXG4gICAgICAgIHN0YXJ0ICsgY2hhbmdlLmZyb20sXG4gICAgICAgIHN0YXJ0ICsgY2hhbmdlLnRvLFxuICAgICAgICBjaGFuZ2UudGV4dCA/IHRoaXMuc2NoZW1hLnRleHQoY2hhbmdlLnRleHQpIDogbnVsbFxuICAgICAgKVxuICAgICAgdGhpcy52aWV3LmRpc3BhdGNoKHRyKVxuICAgIH1cbiAgfVxuXG4gIC8qKlxuICAgKiB0aGlzIGhlbHBlciBmdW5jdGlvbiB0cmFuc2xhdGVzIGZyb20gYSBDb2RlTWlycm9yIHNlbGN0aW9uIHRvIGFcbiAgICogUHJvc2VNaXJyb3Igc2VsZWN0aW9uLkJlY2F1c2UgQ29kZU1pcnJvciB1c2VzIGEgbGluZS9jb2x1bW4gYmFzZWRcbiAgICogaW5kZXhpbmcgc3lzdGVtLGluZGV4RnJvbVBvcyBpcyB1c2VkIHRvIGNvbnZlcnQgdG8gYW4gYWN0dWFsIGNoYXJhY3RlclxuICAgKiBpbmRleC5cbiAgICogQHBhcmFtIGRvY1xuICAgKi9cbiAgYXNQcm9zZU1pcnJvclNlbGVjdGlvbiA9IChkb2M6IFByb3NlbWlycm9yTm9kZTxTY2hlbWE+KSA9PiB7XG4gICAgbGV0IG9mZnNldCA9IHRoaXMuZ2V0UG9zKCkgKyAxXG4gICAgbGV0IGFuY2hvciA9IHRoaXMuY20uaW5kZXhGcm9tUG9zKHRoaXMuY20uZ2V0Q3Vyc29yKCdhbmNob3InKSkgKyBvZmZzZXRcbiAgICBsZXQgaGVhZCA9IHRoaXMuY20uaW5kZXhGcm9tUG9zKHRoaXMuY20uZ2V0Q3Vyc29yKCdoZWFkJykpICsgb2Zmc2V0XG4gICAgcmV0dXJuIFRleHRTZWxlY3Rpb24uY3JlYXRlKGRvYywgYW5jaG9yLCBoZWFkKVxuICB9XG5cbiAgLyoqXG4gICAqIFNlbGVjdGlvbnMgYXJlIGFsc28gc3luY2hyb25pemVkIHRoZSBvdGhlciB3YXksZnJvbSBQcm9zZU1pcnJvciB0b1xuICAgKiBDb2RlTWlycm9yLHVzaW5nIHRoZSB2aWV3J3Mgc2V0U2VsZWN0aW9uIG1ldGhvZC5cbiAgICogQHBhcmFtIGFuY2hvclxuICAgKiBAcGFyYW0gaGVhZFxuICAgKi9cbiAgc2V0U2VsZWN0aW9uID0gKGFuY2hvcjogc3RyaW5nLCBoZWFkOiBzdHJpbmcpOiB2b2lkID0+IHtcbiAgICB0aGlzLmNtLmZvY3VzKClcbiAgICB0aGlzLnVwZGF0aW5nID0gdHJ1ZVxuICAgIHRoaXMuY20uc2V0U2VsZWN0aW9uKHRoaXMuY20ucG9zRnJvbUluZGV4KGFuY2hvciksIHRoaXMuY20ucG9zRnJvbUluZGV4KGhlYWQpKVxuICAgIHRoaXMudXBkYXRpbmcgPSBmYWxzZVxuICB9XG5cbiAgLyoqXG4gICAqIHRoZSBrZXltYXAgYWxzbyBiaW5kcyBrZXlzIGZvciB1bmRvIGFuZCByZWRvLCB3aGljaCB0aGUgb3V0ZXIgZWRpdG9yIHdpbGxcbiAgICogaGFuZGxlLCBhbmQgZm9yIGN0cmwtZW50ZXIsIHdoaWNoLCBpbiBQcm9zZU1pcnJvcidzIGJhc2Uga2V5bWFwLCBjcmVhdGVkc1xuICAgKiBhIG5ldyBwYXJhZ3JhcGggYWZ0ZXIgYSBjb2RlIGJsb2NrLlxuICAgKi9cbiAgY29kZU1pcnJvcktleW1hcCA9ICgpID0+IHtcbiAgICBsZXQgdmlldyA9IHRoaXMudmlld1xuICAgIGxldCBtb2QgPSAvTWFjLy50ZXN0KG5hdmlnYXRvci5wbGF0Zm9ybSkgPyAnQ21kJyA6ICdDdHJsJ1xuXG4gICAgcmV0dXJuIENvZGVNaXJyb3Iubm9ybWFsaXplS2V5TWFwKHtcbiAgICAgIFVwOiAoKSA9PiB0aGlzLm1heWJlRXNjYXBlKCdsaW5lJywgLTEpLFxuICAgICAgTGVmdDogKCkgPT4gdGhpcy5tYXliZUVzY2FwZSgnY2hhcicsIC0xKSxcbiAgICAgIERvd246ICgpID0+IHRoaXMubWF5YmVFc2NhcGUoJ2xpbmUnLCAxKSxcbiAgICAgIFJpZ2h0OiAoKSA9PiB0aGlzLm1heWJlRXNjYXBlKCdjaGFyJywgMSksXG4gICAgICBbYCR7bW9kfS1aYF06ICgpID0+IHVuZG8odmlldy5zdGF0ZSwgdmlldy5kaXNwYXRjaCksXG4gICAgICBbYFNoaWZ0LSR7bW9kfS1aYF06ICgpID0+IHJlZG8odmlldy5zdGF0ZSwgdmlldy5kaXNwYXRjaCksXG4gICAgICBbYCR7bW9kfS1ZYF06ICgpID0+IHJlZG8odmlldy5zdGF0ZSwgdmlldy5kaXNwYXRjaCksXG4gICAgICAnQ3RybC1FbnRlcic6ICgpID0+IHtcbiAgICAgICAgaWYgKGV4aXRDb2RlKHZpZXcuc3RhdGUsIHZpZXcuZGlzcGF0Y2gpKSB2aWV3LmZvY3VzKClcbiAgICAgIH1cbiAgICB9KVxuICB9XG5cbiAgLyoqXG4gICAqIEEgc29tZXdoYXQgdHJpY2t5IGFzcGVjdCBvZiBuZXN0aW5nIGVkaXRvciBsaWtlIHRoaXMgaXMgaGFuZGxpbmcgY3Vyc29yXG4gICAqIG1vdGlvbiBhY3Jvc3MgdGhlIGVkZ2VzIG9mIHRoZSBpbm5lciBlZGl0b3IuIFRoaXMgbm9kZSB2aWV3IHdpbGwgaGF2ZSB0b1xuICAgKiB0YWtlIGNhcmUgb2YgYWxsb3dpbmcgdGhlIHVzZXIgdG8gbW92ZSB0aGUgc2VsZWN0aW9uIG91dCBvZiB0aGUgY29kZSBlZGl0b3IuXG4gICAqIEBwYXJhbSB1bml0XG4gICAqIEBwYXJhbSBkaXJcbiAgICovXG4gIG1heWJlRXNjYXBlID0gKHVuaXQ6IHN0cmluZywgZGlyOiBudW1iZXIpID0+IHtcbiAgICBsZXQgcG9zID0gdGhpcy5jbS5nZXRDdXJzb3IoKVxuXG4gICAgaWYgKFxuICAgICAgdGhpcy5jbS5zb21ldGhpbmdTZWxlY3RlZCgpIHx8XG4gICAgICBwb3MubGluZSAhPT0gKGRpciA8IDAgPyB0aGlzLmNtLmZpcnN0TGluZSgpIDogdGhpcy5jbS5sYXN0TGluZSgpKSB8fFxuICAgICAgKHVuaXQgPT09ICdjaGFyJyAmJiBwb3MuY2ggIT09IChkaXIgPCAwID8gMCA6IHRoaXMuY20uZ2V0TGluZShwb3MubGluZSkubGVuZ3RoKSlcbiAgICApIHtcbiAgICAgIHJldHVybiBDb2RlTWlycm9yLlBhc3NcbiAgICB9XG4gICAgdGhpcy52aWV3LmZvY3VzKClcbiAgICBsZXQgdGFyZ2V0UG9zID0gdGhpcy5nZXRQb3MoKSArIChkaXIgPCAwID8gMCA6IHRoaXMubm9kZS5ub2RlU2l6ZSlcbiAgICBsZXQgc2VsZWN0aW9uID0gU2VsZWN0aW9uLm5lYXIodGhpcy52aWV3LnN0YXRlLmRvYy5yZXNvbHZlKHRhcmdldFBvcyksIGRpcilcbiAgICB0aGlzLnZpZXcuZGlzcGF0Y2godGhpcy52aWV3LnN0YXRlLnRyLnNldFNlbGVjdGlvbihzZWxlY3Rpb24pLnNjcm9sbEludG9WaWV3KCkpXG4gICAgdGhpcy52aWV3LmZvY3VzKClcbiAgfVxuXG4gIC8qKlxuICAgKiB3aGVuIGFuIHVwZGF0ZSBjb21lcyBpbiBmcm9tIHRoZSBlZGl0b3IsIGZvciBleGFtcGxlIGJlY2F1c2Ugb2YgYW4gdW5kbyBhY3Rpb24sXG4gICAqIHdlIGtpbmQgb2YgaGF2ZSB0byBkbyB0aGUgaW52ZXJzZSBvZiB3aGF0IHZhbHVlQ2hhbmdlZCBkaWQtLWNoZWNrIGZvciB0ZXh0IGNoYW5nZXNcbiAgICogYW5kIGlmIHByZXNlbnQsIHByb3BhZ2F0ZSB0aGVuIGZyb20gdGhlIG91dGVyIHRvIGlubmVyIGVkaXRvci5cbiAgICogQHBhcmFtIG5vZGVcbiAgICovXG4gIHVwZGF0ZSA9IChub2RlOiBQcm9zZW1pcnJvck5vZGU8U2NoZW1hPikgPT4ge1xuICAgIGlmIChub2RlLnR5cGUgIT09IHRoaXMubm9kZS50eXBlKSByZXR1cm4gZmFsc2VcbiAgICB0aGlzLm5vZGUgPSBub2RlXG4gICAgbGV0IGNoYW5nZSA9IGNvbXB1dGVDaGFuZ2UodGhpcy5jbS5nZXRWYWx1ZSgpLCBub2RlLnRleHRDb250ZW50KVxuICAgIGlmIChjaGFuZ2UpIHtcbiAgICAgIHRoaXMudXBkYXRpbmcgPSB0cnVlXG4gICAgICB0aGlzLmNtLnJlcGxhY2VSYW5nZShjaGFuZ2UudGV4dCwgdGhpcy5jbS5wb3NGcm9tSW5kZXgoY2hhbmdlLmZyb20pLCB0aGlzLmNtLnBvc0Zyb21JbmRleChjaGFuZ2UudG8pKVxuICAgICAgdGhpcy51cGRhdGluZyA9IGZhbHNlXG4gICAgfVxuICAgIHJldHVybiB0cnVlXG4gIH1cblxuICBzZWxlY3ROb2RlID0gKCkgPT4ge1xuICAgIHRoaXMuY20uZm9jdXMoKVxuICB9XG5cbiAgZGVzdHJveSA9ICgpID0+IHtcbiAgICB0aGlzLmNvbnRhaW5lck5vZGUucmVtb3ZlKClcbiAgICB0aGlzLnZpZXcuZm9jdXMoKVxuICB9XG59XG5cbmZ1bmN0aW9uIGNvbXB1dGVDaGFuZ2Uob2xkVmFsOiBzdHJpbmcsIG5ld1ZhbDogc3RyaW5nKSB7XG4gIGlmIChvbGRWYWwgPT09IG5ld1ZhbCkgcmV0dXJuIG51bGxcbiAgbGV0IHN0YXJ0ID0gMFxuXG4gIGxldCBvbGRFbmQgPSBvbGRWYWwubGVuZ3RoXG5cbiAgbGV0IG5ld0VuZCA9IG5ld1ZhbC5sZW5ndGhcbiAgd2hpbGUgKHN0YXJ0IDwgb2xkRW5kICYmIG9sZFZhbC5jaGFyQ29kZUF0KHN0YXJ0KSA9PT0gbmV3VmFsLmNoYXJDb2RlQXQoc3RhcnQpKSB7XG4gICAgKytzdGFydFxuICB9XG4gIHdoaWxlIChvbGRFbmQgPiBzdGFydCAmJiBuZXdFbmQgPiBzdGFydCAmJiBvbGRWYWwuY2hhckNvZGVBdChvbGRFbmQgLSAxKSA9PT0gbmV3VmFsLmNoYXJDb2RlQXQobmV3RW5kIC0gMSkpIHtcbiAgICBvbGRFbmQtLVxuICAgIG5ld0VuZC0tXG4gIH1cbiAgcmV0dXJuIHsgZnJvbTogc3RhcnQsIHRvOiBvbGRFbmQsIHRleHQ6IG5ld1ZhbC5zbGljZShzdGFydCwgbmV3RW5kKSB9XG59XG4iXX0=