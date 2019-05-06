function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

import { Node } from 'prosemirror-model';

var Element =
/*#__PURE__*/
function () {
  _createClass(Element, [{
    key: "type",
    get: function get() {
      return 'element';
    }
  }]);

  function Element() {
    var options = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {};

    _classCallCheck(this, Element);

    this.options = void 0;
    this.name = void 0;
    this.options = options;
  }

  _createClass(Element, [{
    key: "inputRules",
    value: function inputRules(node) {
      return [];
    }
  }, {
    key: "pasteRules",
    value: function pasteRules(node) {
      return [];
    }
  }, {
    key: "keys",
    value: function keys(node) {
      return {};
    }
  }, {
    key: "update",
    get: function get() {
      return function () {};
    }
  }, {
    key: "plugins",
    get: function get() {
      return [];
    }
  }]);

  return Element;
}();

export { Element as default };
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uL2xpYi9lbGVtZW50LmpzIl0sIm5hbWVzIjpbIk5vZGUiLCJFbGVtZW50Iiwib3B0aW9ucyIsIm5hbWUiLCJub2RlIl0sIm1hcHBpbmdzIjoiOzs7Ozs7QUFFQSxTQUFTQSxJQUFULFFBQXFCLG1CQUFyQjs7SUFFcUJDLE87Ozs7O3dCQUlSO0FBQ1QsYUFBTyxTQUFQO0FBQ0Q7OztBQUVELHFCQUE4QjtBQUFBLFFBQWxCQyxPQUFrQix1RUFBSixFQUFJOztBQUFBOztBQUFBLFNBUDlCQSxPQU84QjtBQUFBLFNBTjlCQyxJQU04QjtBQUM1QixTQUFLRCxPQUFMLEdBQWVBLE9BQWY7QUFDRDs7OzsrQkFVVUUsSSxFQUFZO0FBQ3JCLGFBQU8sRUFBUDtBQUNEOzs7K0JBRVVBLEksRUFBWTtBQUNyQixhQUFPLEVBQVA7QUFDRDs7O3lCQUVJQSxJLEVBQVk7QUFDZixhQUFPLEVBQVA7QUFDRDs7O3dCQWxCWTtBQUNYLGFBQU8sWUFBTSxDQUFFLENBQWY7QUFDRDs7O3dCQUVhO0FBQ1osYUFBTyxFQUFQO0FBQ0Q7Ozs7OztTQWxCa0JILE8iLCJzb3VyY2VzQ29udGVudCI6WyIvLyBAZmxvd1xuXG5pbXBvcnQgeyBOb2RlIH0gZnJvbSAncHJvc2VtaXJyb3ItbW9kZWwnXG5cbmV4cG9ydCBkZWZhdWx0IGNsYXNzIEVsZW1lbnQge1xuICBvcHRpb25zOiBhbnlcbiAgbmFtZTogP3N0cmluZ1xuXG4gIGdldCB0eXBlKCkge1xuICAgIHJldHVybiAnZWxlbWVudCdcbiAgfVxuXG4gIGNvbnN0cnVjdG9yKG9wdGlvbnM6IHt9ID0ge30pIHtcbiAgICB0aGlzLm9wdGlvbnMgPSBvcHRpb25zXG4gIH1cblxuICBnZXQgdXBkYXRlKCkge1xuICAgIHJldHVybiAoKSA9PiB7fVxuICB9XG5cbiAgZ2V0IHBsdWdpbnMoKSB7XG4gICAgcmV0dXJuIFtdXG4gIH1cblxuICBpbnB1dFJ1bGVzKG5vZGU6IE5vZGUpIHtcbiAgICByZXR1cm4gW11cbiAgfVxuXG4gIHBhc3RlUnVsZXMobm9kZTogTm9kZSkge1xuICAgIHJldHVybiBbXVxuICB9XG5cbiAga2V5cyhub2RlOiBOb2RlKSB7XG4gICAgcmV0dXJuIHt9XG4gIH1cbn1cbiJdfQ==