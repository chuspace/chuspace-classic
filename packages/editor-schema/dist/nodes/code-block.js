function _extends() { _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; }; return _extends.apply(this, arguments); }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

function _possibleConstructorReturn(self, call) { if (call && (typeof call === "object" || typeof call === "function")) { return call; } return _assertThisInitialized(self); }

function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }

function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); if (superClass) _setPrototypeOf(subClass, superClass); }

function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf || function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }

/** @jsx h */
import { Fragment, NodeSpec, Node as PMNode, Schema } from 'prosemirror-model';
import { CodeBlock as CodeBlockComponent } from '@chuspace/editor-ui';
import { Node } from '@chuspace/editor-base';
import { h } from 'preact';
import { setBlockType } from 'prosemirror-commands';
import { toggleBlockType } from '@chuspace/editor-commands';

var removeLastNewLine = function removeLastNewLine(dom) {
  var parent = dom && dom.parentElement;

  if (parent && parent.classList.contains('codehilite')) {
    dom.textContent = dom.textContent.replace(/\n$/, '');
  }

  return dom;
};

var CodeBlock =
/*#__PURE__*/
function (_Node) {
  _inherits(CodeBlock, _Node);

  function CodeBlock() {
    var _getPrototypeOf2;

    var _this;

    _classCallCheck(this, CodeBlock);

    for (var _len = arguments.length, args = new Array(_len), _key = 0; _key < _len; _key++) {
      args[_key] = arguments[_key];
    }

    _this = _possibleConstructorReturn(this, (_getPrototypeOf2 = _getPrototypeOf(CodeBlock)).call.apply(_getPrototypeOf2, [this].concat(args)));
    _this.name = 'code_block';
    return _this;
  }

  _createClass(CodeBlock, [{
    key: "commands",
    value: function commands(_ref) {
      var type = _ref.type,
          schema = _ref.schema;
      return function () {
        return toggleBlockType(type, schema.nodes.paragraph);
      };
    }
  }, {
    key: "keys",
    value: function keys(_ref2) {
      var type = _ref2.type;
      return {
        'Shift-Ctrl-\\': setBlockType(type)
      };
    }
  }, {
    key: "schema",
    get: function get() {
      return {
        content: 'text*',
        attrs: {
          language: {
            "default": 'auto'
          }
        },
        marks: '',
        group: 'block',
        code: true,
        defining: true,
        draggable: false,
        parseDOM: [{
          tag: 'pre',
          preserveWhitespace: 'full',
          getAttrs: function getAttrs(domNode) {
            var dom = domNode;
            var language = dom.getAttribute('data-language');
            dom = removeLastNewLine(dom);
            return {
              language: language
            };
          }
        }, // Handle VSCode paste
        // Checking `white-space: pre-wrap` is too aggressive @see ED-2627
        {
          tag: 'div[style]',
          preserveWhitespace: 'full',
          getAttrs: function getAttrs(dom) {
            console.log(dom.style);

            if (dom.style.whiteSpace === 'pre') {
              return {};
            }

            return false;
          },
          // @see ED-5682
          getContent: function getContent(domNode, schema) {
            var dom = domNode;
            var code = Array.from(dom.children).map(function (child) {
              return child.textContent;
            }).filter(function (x) {
              return x !== undefined;
            }).join('\n');
            return code ? Fragment.from(schema.text(code)) : Fragment.empty;
          }
        }, // Handle GitHub/Gist paste
        {
          tag: 'table[style]',
          preserveWhitespace: 'full',
          getAttrs: function getAttrs(dom) {
            console.log(dom);

            if (dom.querySelector('td[class*="blob-code"]')) {
              return {};
            }

            return false;
          }
        }, {
          tag: 'div.code-block',
          preserveWhitespace: 'full',
          getAttrs: function getAttrs(dom) {
            // TODO: ED-5604 Fix it inside `react-syntax-highlighter`
            // Remove line numbers
            var linesCode = dom.querySelector('code');

            if (linesCode && linesCode.querySelector('.react-syntax-highlighter-line-number')) {
              // It's possible to copy without the line numbers too hence this
              // `react-syntax-highlighter-line-number` check, so that we don't remove real code
              linesCode.remove();
            }

            return {};
          }
        }],
        toDOM: function toDOM(node) {
          return ['pre', ['code', {
            'data-language': node.attrs.language
          }, 0]];
        },
        toStatic: function toStatic(props) {
          return h(CodeBlockComponent, _extends({
            key: props.node.currIndex
          }, props));
        }
      };
    }
  }]);

  return CodeBlock;
}(Node);

export { CodeBlock as default };
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uLy4uL2xpYi9ub2Rlcy9jb2RlLWJsb2NrLmpzIl0sIm5hbWVzIjpbIkZyYWdtZW50IiwiTm9kZVNwZWMiLCJOb2RlIiwiUE1Ob2RlIiwiU2NoZW1hIiwiQ29kZUJsb2NrIiwiQ29kZUJsb2NrQ29tcG9uZW50IiwiaCIsInNldEJsb2NrVHlwZSIsInRvZ2dsZUJsb2NrVHlwZSIsInJlbW92ZUxhc3ROZXdMaW5lIiwiZG9tIiwicGFyZW50IiwicGFyZW50RWxlbWVudCIsImNsYXNzTGlzdCIsImNvbnRhaW5zIiwidGV4dENvbnRlbnQiLCJyZXBsYWNlIiwibmFtZSIsInR5cGUiLCJzY2hlbWEiLCJub2RlcyIsInBhcmFncmFwaCIsImNvbnRlbnQiLCJhdHRycyIsImxhbmd1YWdlIiwibWFya3MiLCJncm91cCIsImNvZGUiLCJkZWZpbmluZyIsImRyYWdnYWJsZSIsInBhcnNlRE9NIiwidGFnIiwicHJlc2VydmVXaGl0ZXNwYWNlIiwiZ2V0QXR0cnMiLCJkb21Ob2RlIiwiZ2V0QXR0cmlidXRlIiwiY29uc29sZSIsImxvZyIsInN0eWxlIiwid2hpdGVTcGFjZSIsImdldENvbnRlbnQiLCJBcnJheSIsImZyb20iLCJjaGlsZHJlbiIsIm1hcCIsImNoaWxkIiwiZmlsdGVyIiwieCIsInVuZGVmaW5lZCIsImpvaW4iLCJ0ZXh0IiwiZW1wdHkiLCJxdWVyeVNlbGVjdG9yIiwibGluZXNDb2RlIiwicmVtb3ZlIiwidG9ET00iLCJub2RlIiwidG9TdGF0aWMiLCJwcm9wcyIsImN1cnJJbmRleCJdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7Ozs7Ozs7Ozs7O0FBRUE7QUFFQSxTQUFTQSxRQUFULEVBQW1CQyxRQUFuQixFQUE2QkMsSUFBSSxJQUFJQyxNQUFyQyxFQUE2Q0MsTUFBN0MsUUFBMkQsbUJBQTNEO0FBRUEsU0FBU0MsU0FBUyxJQUFJQyxrQkFBdEIsUUFBZ0QscUJBQWhEO0FBQ0EsU0FBU0osSUFBVCxRQUFxQix1QkFBckI7QUFDQSxTQUFTSyxDQUFULFFBQWtC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QVA7QUFDRCxTQXZFSTtBQXlFTGlDLFFBQUFBLFFBQVEsRUFBRSxrQkFBQUMsS0FBSyxFQUFJO0FBQ2pCLGlCQUFPLEVBQUMsa0JBQUQ7QUFBb0IsWUFBQSxHQUFHLEVBQUVBLEtBQUssQ0FBQ0YsSUFBTixDQUFXRztBQUFwQyxhQUFtREQsS0FBbkQsRUFBUDtBQUNEO0FBM0VJLE9BQVA7QUE2RUQ7Ozs7RUFqRm9DekQsSTs7U0FBbEJHLFMiLCJzb3VyY2VzQ29udGVudCI6WyIvLyBAZmxvd1xuXG4vKiogQGpzeCBoICovXG5cbmltcG9ydCB7IEZyYWdtZW50LCBOb2RlU3BlYywgTm9kZSBhcyBQTU5vZGUsIFNjaGVtYSB9IGZyb20gJ3Byb3NlbWlycm9yLW1vZGVsJ1xuXG5pbXBvcnQgeyBDb2RlQmxvY2sgYXMgQ29kZUJsb2NrQ29tcG9uZW50IH0gZnJvbSAnQGNodXNwYWNlL2VkaXRvci11aSdcbmltcG9ydCB7IE5vZGUgfSBmcm9tICdAY2h1c3BhY2UvZWRpdG9yLWJhc2UnXG5pbXBvcnQgeyBoIH0gZnJvbSAncHJlYWN0J1xuaW1wb3J0IHsgc2V0QmxvY2tUeXBlIH0gZnJvbSAncHJvc2VtaXJyb3ItY29tbWFuZHMnXG5pbXBvcnQgeyB0b2dnbGVCbG9ja1R5cGUgfSBmcm9tICdAY2h1c3BhY2UvZWRpdG9yLWNvbW1hbmRzJ1xuXG5jb25zdCByZW1vdmVMYXN0TmV3TGluZSA9IChkb206IEhUTUxFbGVtZW50KTogSFRNTEVsZW1lbnQgPT4ge1xuICBjb25zdCBwYXJlbnQgPSBkb20gJiYgZG9tLnBhcmVudEVsZW1lbnRcbiAgaWYgKHBhcmVudCAmJiBwYXJlbnQuY2xhc3NMaXN0LmNvbnRhaW5zKCdjb2RlaGlsaXRlJykpIHtcbiAgICBkb20udGV4dENvbnRlbnQgPSBkb20udGV4dENvbnRlbnQucmVwbGFjZSgvXFxuJC8sICcnKVxuICB9XG4gIHJldHVybiBkb21cbn1cblxuZXhwb3J0IGRlZmF1bHQgY2xhc3MgQ29kZUJsb2NrIGV4dGVuZHMgTm9kZSB7XG4gIG5hbWUgPSAnY29kZV9ibG9jaydcblxuICBnZXQgc2NoZW1hKCk6IE5vZGVTcGVjIHtcbiAgICByZXR1cm4ge1xuICAgICAgY29udGVudDogJ3RleHQqJyxcbiAgICAgIGF0dHJzOiB7IGxhbmd1YWdlOiB7IGRlZmF1bHQ6ICdhdXRvJyB9IH0sXG4gICAgICBtYXJrczogJycsXG4gICAgICBncm91cDogJ2Jsb2NrJyxcbiAgICAgIGNvZGU6IHRydWUsXG4gICAgICBkZWZpbmluZzogdHJ1ZSxcbiAgICAgIGRyYWdnYWJsZTogZmFsc2UsXG4gICAgICBwYXJzZURPTTogW1xuICAgICAgICB7XG4gICAgICAgICAgdGFnOiAncHJlJyxcbiAgICAgICAgICBwcmVzZXJ2ZVdoaXRlc3BhY2U6ICdmdWxsJyxcbiAgICAgICAgICBnZXRBdHRyczogKGRvbU5vZGU6IFBNTm9kZSkgPT4ge1xuICAgICAgICAgICAgbGV0IGRvbSA9IGRvbU5vZGVcbiAgICAgICAgICAgIGNvbnN0IGxhbmd1YWdlID0gZG9tLmdldEF0dHJpYnV0ZSgnZGF0YS1sYW5ndWFnZScpXG4gICAgICAgICAgICBkb20gPSByZW1vdmVMYXN0TmV3TGluZShkb20pXG4gICAgICAgICAgICByZXR1cm4geyBsYW5ndWFnZSB9XG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICAvLyBIYW5kbGUgVlNDb2RlIHBhc3RlXG4gICAgICAgIC8vIENoZWNraW5nIGB3aGl0ZS1zcGFjZTogcHJlLXdyYXBgIGlzIHRvbyBhZ2dyZXNzaXZlIEBzZWUgRUQtMjYyN1xuICAgICAgICB7XG4gICAgICAgICAgdGFnOiAnZGl2W3N0eWxlXScsXG4gICAgICAgICAgcHJlc2VydmVXaGl0ZXNwYWNlOiAnZnVsbCcsXG4gICAgICAgICAgZ2V0QXR0cnM6IChkb206IFBNTm9kZSkgPT4ge1xuICAgICAgICAgICAgY29uc29sZS5sb2coZG9tLnN0eWxlKVxuICAgICAgICAgICAgaWYgKGRvbS5zdHlsZS53aGl0ZVNwYWNlID09PSAncHJlJykge1xuICAgICAgICAgICAgICByZXR1cm4ge31cbiAgICAgICAgICAgIH1cbiAgICAgICAgICAgIHJldHVybiBmYWxzZVxuICAgICAgICAgIH0sXG4gICAgICAgICAgLy8gQHNlZSBFRC01NjgyXG4gICAgICAgICAgZ2V0Q29udGVudDogKGRvbU5vZGU6IFBNTm9kZSwgc2NoZW1hOiBTY2hlbWEpID0+IHtcbiAgICAgICAgICAgIGNvbnN0IGRvbSA9IGRvbU5vZGVcbiAgICAgICAgICAgIGNvbnN0IGNvZGUgPSBBcnJheS5mcm9tKGRvbS5jaGlsZHJlbilcbiAgICAgICAgICAgICAgLm1hcChjaGlsZCA9PiBjaGlsZC50ZXh0Q29udGVudClcbiAgICAgICAgICAgICAgLmZpbHRlcih4ID0+IHggIT09IHVuZGVmaW5lZClcbiAgICAgICAgICAgICAgLmpvaW4oJ1xcbicpXG4gICAgICAgICAgICByZXR1cm4gY29kZSA/IEZyYWdtZW50LmZyb20oc2NoZW1hLnRleHQoY29kZSkpIDogRnJhZ21lbnQuZW1wdHlcbiAgICAgICAgICB9XG4gICAgICAgIH0sXG4gICAgICAgIC8vIEhhbmRsZSBHaXRIdWIvR2lzdCBwYXN0ZVxuICAgICAgICB7XG4gICAgICAgICAgdGFnOiAndGFibGVbc3R5bGVdJyxcbiAgICAgICAgICBwcmVzZXJ2ZVdoaXRlc3BhY2U6ICdmdWxsJyxcbiAgICAgICAgICBnZXRBdHRyczogKGRvbTogUE1Ob2RlKSA9PiB7XG4gICAgICAgICAgICBjb25zb2xlLmxvZyhkb20pXG4gICAgICAgICAgICBpZiAoZG9tLnF1ZXJ5U2VsZWN0b3IoJ3RkW2NsYXNzKj1cImJsb2ItY29kZVwiXScpKSB7XG4gICAgICAgICAgICAgIHJldHVybiB7fVxuICAgICAgICAgICAgfVxuICAgICAgICAgICAgcmV0dXJuIGZhbHNlXG4gICAgICAgICAgfVxuICAgICAgICB9LFxuICAgICAgICB7XG4gICAgICAgICAgdGFnOiAnZGl2LmNvZGUtYmxvY2snLFxuICAgICAgICAgIHByZXNlcnZlV2hpdGVzcGFjZTogJ2Z1bGwnLFxuICAgICAgICAgIGdldEF0dHJzOiAoZG9tOiBQTU5vZGUpID0+IHtcbiAgICAgICAgICAgIC8vIFRPRE86IEVELTU2MDQgRml4IGl0IGluc2lkZSBgcmVhY3Qtc3ludGF4LWhpZ2hsaWdodGVyYFxuICAgICAgICAgICAgLy8gUmVtb3ZlIGxpbmUgbnVtYmVyc1xuICAgICAgICAgICAgY29uc3QgbGluZXNDb2RlID0gZG9tLnF1ZXJ5U2VsZWN0b3IoJ2NvZGUnKVxuICAgICAgICAgICAgaWYgKGxpbmVzQ29kZSAmJiBsaW5lc0NvZGUucXVlcnlTZWxlY3RvcignLnJlYWN0LXN5bnRheC1oaWdobGlnaHRlci1saW5lLW51bWJlcicpKSB7XG4gICAgICAgICAgICAgIC8vIEl0J3MgcG9zc2libGUgdG8gY29weSB3aXRob3V0IHRoZSBsaW5lIG51bWJlcnMgdG9vIGhlbmNlIHRoaXNcbiAgICAgICAgICAgICAgLy8gYHJlYWN0LXN5bnRheC1oaWdobGlnaHRlci1saW5lLW51bWJlcmAgY2hlY2ssIHNvIHRoYXQgd2UgZG9uJ3QgcmVtb3ZlIHJlYWwgY29kZVxuICAgICAgICAgICAgICBsaW5lc0NvZGUucmVtb3ZlKClcbiAgICAgICAgICAgIH1cbiAgICAgICAgICAgIHJldHVybiB7fVxuICAgICAgICAgIH1cbiAgICAgICAgfVxuICAgICAgXSxcbiAgICAgIHRvRE9NKG5vZGU6IFBNTm9kZSkge1xuICAgICAgICByZXR1cm4gWydwcmUnLCBbJ2NvZGUnLCB7ICdkYXRhLWxhbmd1YWdlJzogbm9kZS5hdHRycy5sYW5ndWFnZSB9LCAwXV1cbiAgICAgIH0sXG5cbiAgICAgIHRvU3RhdGljOiBwcm9wcyA9PiB7XG4gICAgICAgIHJldHVybiA8Q29kZUJsb2NrQ29tcG9uZW50IGtleT17cHJvcHMubm9kZS5jdXJySW5kZXh9IHsuLi5wcm9wc30gLz5cbiAgICAgIH1cbiAgICB9XG4gIH1cblxuICBjb21tYW5kcyh7IHR5cGUsIHNjaGVtYSB9OiBQTU5vZGUpIHtcbiAgICByZXR1cm4gKCkgPT4gdG9nZ2xlQmxvY2tUeXBlKHR5cGUsIHNjaGVtYS5ub2Rlcy5wYXJhZ3JhcGgpXG4gIH1cblxuICBrZXlzKHsgdHlwZSB9OiBQTU5vZGUpIHtcbiAgICByZXR1cm4ge1xuICAgICAgJ1NoaWZ0LUN0cmwtXFxcXCc6IHNldEJsb2NrVHlwZSh0eXBlKVxuICAgIH1cbiAgfVxufVxuIl19