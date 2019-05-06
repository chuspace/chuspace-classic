function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance"); }

function _iterableToArrayLimit(arr, i) { var _arr = []; var _n = true; var _d = false; var _e = undefined; try { for (var _i = arr[Symbol.iterator](), _s; !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

function _objectSpread(target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i] != null ? arguments[i] : {}; var ownKeys = Object.keys(source); if (typeof Object.getOwnPropertySymbols === 'function') { ownKeys = ownKeys.concat(Object.getOwnPropertySymbols(source).filter(function (sym) { return Object.getOwnPropertyDescriptor(source, sym).enumerable; })); } ownKeys.forEach(function (key) { _defineProperty(target, key, source[key]); }); } return target; }

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

function _toConsumableArray(arr) { return _arrayWithoutHoles(arr) || _iterableToArray(arr) || _nonIterableSpread(); }

function _nonIterableSpread() { throw new TypeError("Invalid attempt to spread non-iterable instance"); }

function _iterableToArray(iter) { if (Symbol.iterator in Object(iter) || Object.prototype.toString.call(iter) === "[object Arguments]") return Array.from(iter); }

function _arrayWithoutHoles(arr) { if (Array.isArray(arr)) { for (var i = 0, arr2 = new Array(arr.length); i < arr.length; i++) { arr2[i] = arr[i]; } return arr2; } }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

import * as marks from './nodes';
import * as nodes from './marks';
import * as plugins from '@chuspace/editor-plugins';
import { Schema } from 'prosemirror-model';
import { keymap } from 'prosemirror-keymap';
import toArray from 'lodash/toArray';

var SchemaManager =
/*#__PURE__*/
function () {
  function SchemaManager() {
    var elements = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : [];

    _classCallCheck(this, SchemaManager);

    this.elements = void 0;
    this.elements = elements;
  }

  _createClass(SchemaManager, [{
    key: "keymaps",
    value: function keymaps(_ref) {
      var schema = _ref.schema;
      var elementKeymaps = this.elements.filter(function (element) {
        return ['element'].includes(element.type);
      }).filter(function (element) {
        return element.keys;
      }).map(function (element) {
        return element.keys({
          schema: schema
        });
      });
      var nodeMarkKeymaps = this.elements.filter(function (element) {
        return ['node', 'mark'].includes(element.type);
      }).filter(function (element) {
        return element.keys;
      }).map(function (element) {
        return element.keys({
          type: schema["".concat(element.type, "s")][element.name],
          schema: schema
        });
      });
      return [].concat(_toConsumableArray(elementKeymaps), _toConsumableArray(nodeMarkKeymaps)).map(function (keys) {
        return keymap(keys);
      });
    }
  }, {
    key: "inputRules",
    value: function inputRules(_ref2) {
      var schema = _ref2.schema;
      var elementInputRules = this.elements.filter(function (element) {
        return ['element'].includes(element.type);
      }).filter(function (element) {
        return element.inputRules;
      }).map(function (element) {
        return element.inputRules({
          schema: schema
        });
      });
      var nodeMarkInputRules = this.elements.filter(function (element) {
        return ['node', 'mark'].includes(element.type);
      }).filter(function (element) {
        return element.inputRules;
      }).map(function (element) {
        return element.inputRules({
          type: schema["".concat(element.type, "s")][element.name],
          schema: schema
        });
      });
      return [].concat(_toConsumableArray(elementInputRules), _toConsumableArray(nodeMarkInputRules)).reduce(function (allInputRules, inputRules) {
        return [].concat(_toConsumableArray(allInputRules), _toConsumableArray(inputRules));
      }, []);
    }
  }, {
    key: "pasteRules",
    value: function pasteRules(_ref3) {
      var schema = _ref3.schema;
      var elementPasteRules = this.elements.filter(function (element) {
        return ['element'].includes(element.type);
      }).filter(function (element) {
        return element.pasteRules;
      }).map(function (element) {
        return element.pasteRules({
          schema: schema
        });
      });
      var nodeMarkPasteRules = this.elements.filter(function (element) {
        return ['node', 'mark'].includes(element.type);
      }).filter(function (element) {
        return element.pasteRules;
      }).map(function (element) {
        return element.pasteRules({
          type: schema["".concat(element.type, "s")][element.name],
          schema: schema
        });
      });
      return [].concat(_toConsumableArray(elementPasteRules), _toConsumableArray(nodeMarkPasteRules)).reduce(function (allPasteRules, pasteRules) {
        return [].concat(_toConsumableArray(allPasteRules), _toConsumableArray(pasteRules));
      }, []);
    }
  }, {
    key: "commands",
    value: function commands(_ref4) {
      var schema = _ref4.schema,
          view = _ref4.view,
          editable = _ref4.editable;
      return this.elements.filter(function (element) {
        return element.commands;
      }).reduce(function (allCommands, element) {
        var name = element.name,
            type = element.type;
        var commands = {};
        var value = element.commands(_objectSpread({
          schema: schema
        }, ['node', 'mark'].includes(type) ? {
          type: schema["".concat(type, "s")][name]
        } : {}));

        if (Array.isArray(value)) {
          commands[name] = function (attrs) {
            return value.forEach(function (callback) {
              if (!editable) {
                return false;
              }

              view.focus();
              return callback(attrs)(view.state, view.dispatch, view);
            });
          };
        } else if (typeof value === 'function') {
          commands[name] = function (attrs) {
            if (!editable) {
              return false;
            }

            view.focus();
            return value(attrs)(view.state, view.dispatch, view);
          };
        } else if (typeof value === 'object') {
          Object.entries(value).forEach(function (_ref5) {
            var _ref6 = _slicedToArray(_ref5, 2),
                commandName = _ref6[0],
                commandValue = _ref6[1];

            if (Array.isArray(commandValue)) {
              commands[commandName] = function (attrs) {
                return commandValue.forEach(function (callback) {
                  if (!editable) {
                    return false;
                  }

                  view.focus();
                  return callback(attrs)(view.state, view.dispatch, view);
                });
              };
            } else {
              commands[commandName] = function (attrs) {
                if (!editable) {
                  return false;
                }

                view.focus();
                return commandValue(attrs)(view.state, view.dispatch, view);
              };
            }
          });
        }

        return _objectSpread({}, allCommands, commands);
      }, {});
    }
  }, {
    key: "nodes",
    get: function get() {
      return this.elements.filter(function (element) {
        return element.type === 'node';
      }).reduce(function (nodes, _ref7) {
        var name = _ref7.name,
            schema = _ref7.schema;
        return _objectSpread({}, nodes, _defineProperty({}, name, schema));
      }, {});
    }
  }, {
    key: "marks",
    get: function get() {
      return this.elements.filter(function (element) {
        return element.type === 'mark';
      }).reduce(function (marks, _ref8) {
        var name = _ref8.name,
            schema = _ref8.schema;
        return _objectSpread({}, marks, _defineProperty({}, name, schema));
      }, {});
    }
  }, {
    key: "plugins",
    get: function get() {
      return this.elements.filter(function (element) {
        return element.plugins;
      }).reduce(function (allPlugins, _ref9) {
        var plugins = _ref9.plugins;
        return [].concat(_toConsumableArray(allPlugins), _toConsumableArray(plugins));
      }, []);
    }
  }]);

  return SchemaManager;
}();

export var manager = new SchemaManager([].concat(_toConsumableArray(toArray(marks).map(function (Mark) {
  return new Mark();
})), _toConsumableArray(toArray(plugins).map(function (Plugin) {
  return new Plugin();
})), _toConsumableArray(toArray(nodes).map(function (Node) {
  return new Node();
}))));
export var schema = new Schema({
  nodes: manager.nodes,
  marks: manager.marks
});
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uL2xpYi9pbmRleC5qcyJdLCJuYW1lcyI6WyJtYXJrcyIsIm5vZGVzIiwicGx1Z2lucyIsIlNjaGVtYSIsImtleW1hcCIsInRvQXJyYXkiLCJTY2hlbWFNYW5hZ2VyIiwiZWxlbWVudHMiLCJzY2hlbWEiLCJlbGVtZW50S2V5bWFwcyIsImZpbHRlciIsImVsZW1lbnQiLCJpbmNsdWRlcyIsInR5cGUiLCJrZXlzIiwibWFwIiwibm9kZU1hcmtLZXltYXBzIiwibmFtZSIsImVsZW1lbnRJbnB1dFJ1bGVzIiwiaW5wdXRSdWxlcyIsIm5vZGVNYXJrSW5wdXRSdWxlcyIsInJlZHVjZSIsImFsbElucHV0UnVsZXMiLCJlbGVtZW50UGFzdGVSdWxlcyIsInBhc3RlUnVsZXMiLCJub2RlTWFya1Bhc3RlUnVsZXMiLCJhbGxQYXN0ZVJ1bGVzIiwidmlldyIsImVkaXRhYmxlIiwiY29tbWFuZHMiLCJhbGxDb21tYW5kcyIsInZhbHVlIiwiQXJyYXkiLCJpc0FycmF5IiwiYXR0cnMiLCJmb3JFYWNoIiwiY2FsbGJhY2siLCJmb2N1cyIsInN0YXRlIiwiZGlzcGF0Y2giLCJPYmplY3QiLCJlbnRyaWVzIiwiY29tbWFuZE5hbWUiLCJjb21tYW5kVmFsdWUiLCJhbGxQbHVnaW5zIiwibWFuYWdlciIsIk1hcmsiLCJQbHVnaW4iLCJOb2RlIl0sIm1hcHBpbmdzIjoiOzs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7OztBQUVBLE9BQU8sS0FBS0EsS0FBWixNQUF1QixTQUF2QjtBQUNBLE9BQU8sS0FBS0MsS0FBWixNQUF1QixTQUF2QjtBQUNBLE9BQU8sS0FBS0MsT0FBWixNQUF5QiwwQkFBekI7QUFFQSxTQUFTQyxNQUFULFFBQXVCLG1CQUF2QjtBQUNBLFNBQVNDLE1BQVQsUUFBdUIsb0JBQXZCO0FBQ0EsT0FBT0MsT0FBUCxNQUFvQixnQkFBcEI7O0lBRU1DLGE7OztBQUdKLDJCQUErQjtBQUFBLFFBQW5CQyxRQUFtQix1RUFBSixFQUFJOztBQUFBOztBQUFBLFNBRi9CQSxR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Q0csVUFBQUMsT0FBTztBQUFBLGVBQUlBLE9BQU8sQ0FBQ1QsT0FBWjtBQUFBLE9BRFYsRUFFSm1CLE1BRkksQ0FFRyxVQUFDdUIsVUFBRDtBQUFBLFlBQWUxQyxPQUFmLFNBQWVBLE9BQWY7QUFBQSw0Q0FBaUMwQyxVQUFqQyxzQkFBZ0QxQyxPQUFoRDtBQUFBLE9BRkgsRUFFNkQsRUFGN0QsQ0FBUDtBQUdEOzs7Ozs7QUFnSUgsT0FBTyxJQUFNMkMsT0FBTyxHQUFHLElBQUl2QyxhQUFKLDhCQUNsQkQsT0FBTyxDQUFDTCxLQUFELENBQVAsQ0FBZWUsR0FBZixDQUFtQixVQUFBK0IsSUFBSTtBQUFBLFNBQUksSUFBSUEsSUFBSixFQUFKO0FBQUEsQ0FBdkIsQ0FEa0Isc0JBRWxCekMsT0FBTyxDQUFDSCxPQUFELENBQVAsQ0FBaUJhLEdBQWpCLENBQXFCLFVBQUFnQyxNQUFNO0FBQUEsU0FBSSxJQUFJQSxNQUFKLEVBQUo7QUFBQSxDQUEzQixDQUZrQixzQkFHbEIxQyxPQUFPLENBQUNKLEtBQUQsQ0FBUCxDQUFlYyxHQUFmLENBQW1CLFVBQUFpQyxJQUFJO0FBQUEsU0FBSSxJQUFJQSxJQUFKLEVBQUo7QUFBQSxDQUF2QixDQUhrQixHQUFoQjtBQU1QLE9BQU8sSUFBTXhDLE1BQU0sR0FBRyxJQUFJTCxNQUFKLENBQVc7QUFDL0JGLEVBQUFBLEtBQUssRUFBRTRDLE9BQU8sQ0FBQzVDLEtBRGdCO0FBRS9CRCxFQUFBQSxLQUFLLEVBQUU2QyxPQUFPLENBQUM3QztBQUZnQixDQUFYLENBQWYiLCJzb3VyY2VzQ29udGVudCI6WyIvLyBAZmxvd1xuXG5pbXBvcnQgKiBhcyBtYXJrcyBmcm9tICcuL25vZGVzJ1xuaW1wb3J0ICogYXMgbm9kZXMgZnJvbSAnLi9tYXJrcydcbmltcG9ydCAqIGFzIHBsdWdpbnMgZnJvbSAnQGNodXNwYWNlL2VkaXRvci1wbHVnaW5zJ1xuXG5pbXBvcnQgeyBTY2hlbWEgfSBmcm9tICdwcm9zZW1pcnJvci1tb2RlbCdcbmltcG9ydCB7IGtleW1hcCB9IGZyb20gJ3Byb3NlbWlycm9yLWtleW1hcCdcbmltcG9ydCB0b0FycmF5IGZyb20gJ2xvZGFzaC90b0FycmF5J1xuXG5jbGFzcyBTY2hlbWFNYW5hZ2VyIHtcbiAgZWxlbWVudHM6IFtdXG5cbiAgY29uc3RydWN0b3IoZWxlbWVudHM6IFtdID0gW10pIHtcbiAgICB0aGlzLmVsZW1lbnRzID0gZWxlbWVudHNcbiAgfVxuXG4gIGdldCBub2RlcygpIHtcbiAgICByZXR1cm4gdGhpcy5lbGVtZW50c1xuICAgICAgLmZpbHRlcihlbGVtZW50ID0+IGVsZW1lbnQudHlwZSA9PT0gJ25vZGUnKVxuICAgICAgLnJlZHVjZShcbiAgICAgICAgKG5vZGVzLCB7IG5hbWUsIHNjaGVtYSB9KSA9PiAoe1xuICAgICAgICAgIC4uLm5vZGVzLFxuICAgICAgICAgIFtuYW1lXTogc2NoZW1hXG4gICAgICAgIH0pLFxuICAgICAgICB7fVxuICAgICAgKVxuICB9XG5cbiAgZ2V0IG1hcmtzKCkge1xuICAgIHJldHVybiB0aGlzLmVsZW1lbnRzXG4gICAgICAuZmlsdGVyKGVsZW1lbnQgPT4gZWxlbWVudC50eXBlID09PSAnbWFyaycpXG4gICAgICAucmVkdWNlKFxuICAgICAgICAobWFya3MsIHsgbmFtZSwgc2NoZW1hIH0pID0+ICh7XG4gICAgICAgICAgLi4ubWFya3MsXG4gICAgICAgICAgW25hbWVdOiBzY2hlbWFcbiAgICAgICAgfSksXG4gICAgICAgIHt9XG4gICAgICApXG4gIH1cblxuICBnZXQgcGx1Z2lucygpOiBBcnJheTxhbnk+IHtcbiAgICByZXR1cm4gdGhpcy5lbGVtZW50c1xuICAgICAgLmZpbHRlcihlbGVtZW50ID0+IGVsZW1lbnQucGx1Z2lucylcbiAgICAgIC5yZWR1Y2UoKGFsbFBsdWdpbnMsIHsgcGx1Z2lucyB9KSA9PiBbLi4uYWxsUGx1Z2lucywgLi4ucGx1Z2luc10sIFtdKVxuICB9XG5cbiAga2V5bWFwcyh7IHNjaGVtYSB9OiBhbnkpOiBBcnJheTxhbnk+IHtcbiAgICBjb25zdCBlbGVtZW50S2V5bWFwcyA9IHRoaXMuZWxlbWVudHNcbiAgICAgIC5maWx0ZXIoZWxlbWVudCA9PiBbJ2VsZW1lbnQnXS5pbmNsdWRlcyhlbGVtZW50LnR5cGUpKVxuICAgICAgLmZpbHRlcihlbGVtZW50ID0+IGVsZW1lbnQua2V5cylcbiAgICAgIC5tYXAoZWxlbWVudCA9PiBlbGVtZW50LmtleXMoeyBzY2hlbWEgfSkpXG5cbiAgICBjb25zdCBub2RlTWFya0tleW1hcHMgPSB0aGlzLmVsZW1lbnRzXG4gICAgICAuZmlsdGVyKGVsZW1lbnQgPT4gWydub2RlJywgJ21hcmsnXS5pbmNsdWRlcyhlbGVtZW50LnR5cGUpKVxuICAgICAgLmZpbHRlcihlbGVtZW50ID0+IGVsZW1lbnQua2V5cylcbiAgICAgIC5tYXAoZWxlbWVudCA9PlxuICAgICAgICBlbGVtZW50LmtleXMoe1xuICAgICAgICAgIHR5cGU6IHNjaGVtYVtgJHtlbGVtZW50LnR5cGV9c2BdW2VsZW1lbnQubmFtZV0sXG4gICAgICAgICAgc2NoZW1hXG4gICAgICAgIH0pXG4gICAgICApXG5cbiAgICByZXR1cm4gWy4uLmVsZW1lbnRLZXltYXBzLCAuLi5ub2RlTWFya0tleW1hcHNdLm1hcChrZXlzID0+IGtleW1hcChrZXlzKSlcbiAgfVxuXG4gIGlucHV0UnVsZXMoeyBzY2hlbWEgfTogYW55KSB7XG4gICAgY29uc3QgZWxlbWVudElucHV0UnVsZXMgPSB0aGlzLmVsZW1lbnRzXG4gICAgICAuZmlsdGVyKGVsZW1lbnQgPT4gWydlbGVtZW50J10uaW5jbHVkZXMoZWxlbWVudC50eXBlKSlcbiAgICAgIC5maWx0ZXIoZWxlbWVudCA9PiBlbGVtZW50LmlucHV0UnVsZXMpXG4gICAgICAubWFwKGVsZW1lbnQgPT4gZWxlbWVudC5pbnB1dFJ1bGVzKHsgc2NoZW1hIH0pKVxuXG4gICAgY29uc3Qgbm9kZU1hcmtJbnB1dFJ1bGVzID0gdGhpcy5lbGVtZW50c1xuICAgICAgLmZpbHRlcihlbGVtZW50ID0+IFsnbm9kZScsICdtYXJrJ10uaW5jbHVkZXMoZWxlbWVudC50eXBlKSlcbiAgICAgIC5maWx0ZXIoZWxlbWVudCA9PiBlbGVtZW50LmlucHV0UnVsZXMpXG4gICAgICAubWFwKGVsZW1lbnQgPT5cbiAgICAgICAgZWxlbWVudC5pbnB1dFJ1bGVzKHtcbiAgICAgICAgICB0eXBlOiBzY2hlbWFbYCR7ZWxlbWVudC50eXBlfXNgXVtlbGVtZW50Lm5hbWVdLFxuICAgICAgICAgIHNjaGVtYVxuICAgICAgICB9KVxuICAgICAgKVxuXG4gICAgcmV0dXJuIFsuLi5lbGVtZW50SW5wdXRSdWxlcywgLi4ubm9kZU1hcmtJbnB1dFJ1bGVzXS5yZWR1Y2UoXG4gICAgICAoYWxsSW5wdXRSdWxlcywgaW5wdXRSdWxlcykgPT4gWy4uLmFsbElucHV0UnVsZXMsIC4uLmlucHV0UnVsZXNdLFxuICAgICAgW11cbiAgICApXG4gIH1cblxuICBwYXN0ZVJ1bGVzKHsgc2NoZW1hIH06IGFueSkge1xuICAgIGNvbnN0IGVsZW1lbnRQYXN0ZVJ1bGVzID0gdGhpcy5lbGVtZW50c1xuICAgICAgLmZpbHRlcihlbGVtZW50ID0+IFsnZWxlbWVudCddLmluY2x1ZGVzKGVsZW1lbnQudHlwZSkpXG4gICAgICAuZmlsdGVyKGVsZW1lbnQgPT4gZWxlbWVudC5wYXN0ZVJ1bGVzKVxuICAgICAgLm1hcChlbGVtZW50ID0+IGVsZW1lbnQucGFzdGVSdWxlcyh7IHNjaGVtYSB9KSlcblxuICAgIGNvbnN0IG5vZGVNYXJrUGFzdGVSdWxlcyA9IHRoaXMuZWxlbWVudHNcbiAgICAgIC5maWx0ZXIoZWxlbWVudCA9PiBbJ25vZGUnLCAnbWFyayddLmluY2x1ZGVzKGVsZW1lbnQudHlwZSkpXG4gICAgICAuZmlsdGVyKGVsZW1lbnQgPT4gZWxlbWVudC5wYXN0ZVJ1bGVzKVxuICAgICAgLm1hcChlbGVtZW50ID0+XG4gICAgICAgIGVsZW1lbnQucGFzdGVSdWxlcyh7XG4gICAgICAgICAgdHlwZTogc2NoZW1hW2Ake2VsZW1lbnQudHlwZX1zYF1bZWxlbWVudC5uYW1lXSxcbiAgICAgICAgICBzY2hlbWFcbiAgICAgICAgfSlcbiAgICAgIClcblxuICAgIHJldHVybiBbLi4uZWxlbWVudFBhc3RlUnVsZXMsIC4uLm5vZGVNYXJrUGFzdGVSdWxlc10ucmVkdWNlKFxuICAgICAgKGFsbFBhc3RlUnVsZXMsIHBhc3RlUnVsZXMpID0+IFsuLi5hbGxQYXN0ZVJ1bGVzLCAuLi5wYXN0ZVJ1bGVzXSxcbiAgICAgIFtdXG4gICAgKVxuICB9XG5cbiAgY29tbWFuZHMoeyBzY2hlbWEsIHZpZXcsIGVkaXRhYmxlIH06IGFueSk6IGFueSB7XG4gICAgcmV0dXJuIHRoaXMuZWxlbWVudHNcbiAgICAgIC5maWx0ZXIoZWxlbWVudCA9PiBlbGVtZW50LmNvbW1hbmRzKVxuICAgICAgLnJlZHVjZSgoYWxsQ29tbWFuZHMsIGVsZW1lbnQpID0+IHtcbiAgICAgICAgY29uc3QgeyBuYW1lLCB0eXBlIH0gPSBlbGVtZW50XG4gICAgICAgIGNvbnN0IGNvbW1hbmRzID0ge31cbiAgICAgICAgY29uc3QgdmFsdWUgPSBlbGVtZW50LmNvbW1hbmRzKHtcbiAgICAgICAgICBzY2hlbWEsXG4gICAgICAgICAgLi4uKFsnbm9kZScsICdtYXJrJ10uaW5jbHVkZXModHlwZSlcbiAgICAgICAgICAgID8ge1xuICAgICAgICAgICAgICAgIHR5cGU6IHNjaGVtYVtgJHt0eXBlfXNgXVtuYW1lXVxuICAgICAgICAgICAgICB9XG4gICAgICAgICAgICA6IHt9KVxuICAgICAgICB9KVxuXG4gICAgICAgIGlmIChBcnJheS5pc0FycmF5KHZhbHVlKSkge1xuICAgICAgICAgIGNvbW1hbmRzW25hbWVdID0gYXR0cnMgPT5cbiAgICAgICAgICAgIHZhbHVlLmZvckVhY2goY2FsbGJhY2sgPT4ge1xuICAgICAgICAgICAgICBpZiAoIWVkaXRhYmxlKSB7XG4gICAgICAgICAgICAgICAgcmV0dXJuIGZhbHNlXG4gICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgdmlldy5mb2N1cygpXG4gICAgICAgICAgICAgIHJldHVybiBjYWxsYmFjayhhdHRycykodmlldy5zdGF0ZSwgdmlldy5kaXNwYXRjaCwgdmlldylcbiAgICAgICAgICAgIH0pXG4gICAgICAgIH0gZWxzZSBpZiAodHlwZW9mIHZhbHVlID09PSAnZnVuY3Rpb24nKSB7XG4gICAgICAgICAgY29tbWFuZHNbbmFtZV0gPSBhdHRycyA9PiB7XG4gICAgICAgICAgICBpZiAoIWVkaXRhYmxlKSB7XG4gICAgICAgICAgICAgIHJldHVybiBmYWxzZVxuICAgICAgICAgICAgfVxuICAgICAgICAgICAgdmlldy5mb2N1cygpXG4gICAgICAgICAgICByZXR1cm4gdmFsdWUoYXR0cnMpKHZpZXcuc3RhdGUsIHZpZXcuZGlzcGF0Y2gsIHZpZXcpXG4gICAgICAgICAgfVxuICAgICAgICB9IGVsc2UgaWYgKHR5cGVvZiB2YWx1ZSA9PT0gJ29iamVjdCcpIHtcbiAgICAgICAgICBPYmplY3QuZW50cmllcyh2YWx1ZSkuZm9yRWFjaCgoW2NvbW1hbmROYW1lLCBjb21tYW5kVmFsdWVdKSA9PiB7XG4gICAgICAgICAgICBpZiAoQXJyYXkuaXNBcnJheShjb21tYW5kVmFsdWUpKSB7XG4gICAgICAgICAgICAgIGNvbW1hbmRzW2NvbW1hbmROYW1lXSA9IGF0dHJzID0+XG4gICAgICAgICAgICAgICAgY29tbWFuZFZhbHVlLmZvckVhY2goY2FsbGJhY2sgPT4ge1xuICAgICAgICAgICAgICAgICAgaWYgKCFlZGl0YWJsZSkge1xuICAgICAgICAgICAgICAgICAgICByZXR1cm4gZmFsc2VcbiAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICAgIHZpZXcuZm9jdXMoKVxuICAgICAgICAgICAgICAgICAgcmV0dXJuIGNhbGxiYWNrKGF0dHJzKSh2aWV3LnN0YXRlLCB2aWV3LmRpc3BhdGNoLCB2aWV3KVxuICAgICAgICAgICAgICAgIH0pXG4gICAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgICBjb21tYW5kc1tjb21tYW5kTmFtZV0gPSBhdHRycyA9PiB7XG4gICAgICAgICAgICAgICAgaWYgKCFlZGl0YWJsZSkge1xuICAgICAgICAgICAgICAgICAgcmV0dXJuIGZhbHNlXG4gICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgIHZpZXcuZm9jdXMoKVxuICAgICAgICAgICAgICAgIHJldHVybiBjb21tYW5kVmFsdWUoYXR0cnMpKHZpZXcuc3RhdGUsIHZpZXcuZGlzcGF0Y2gsIHZpZXcpXG4gICAgICAgICAgICAgIH1cbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9KVxuICAgICAgICB9XG5cbiAgICAgICAgcmV0dXJuIHtcbiAgICAgICAgICAuLi5hbGxDb21tYW5kcyxcbiAgICAgICAgICAuLi5jb21tYW5kc1xuICAgICAgICB9XG4gICAgICB9LCB7fSlcbiAgfVxufVxuXG5leHBvcnQgY29uc3QgbWFuYWdlciA9IG5ldyBTY2hlbWFNYW5hZ2VyKFtcbiAgLi4udG9BcnJheShtYXJrcykubWFwKE1hcmsgPT4gbmV3IE1hcmsoKSksXG4gIC4uLnRvQXJyYXkocGx1Z2lucykubWFwKFBsdWdpbiA9PiBuZXcgUGx1Z2luKCkpLFxuICAuLi50b0FycmF5KG5vZGVzKS5tYXAoTm9kZSA9PiBuZXcgTm9kZSgpKVxuXSlcblxuZXhwb3J0IGNvbnN0IHNjaGVtYSA9IG5ldyBTY2hlbWEoe1xuICBub2RlczogbWFuYWdlci5ub2RlcyxcbiAgbWFya3M6IG1hbmFnZXIubWFya3Ncbn0pXG4iXX0=