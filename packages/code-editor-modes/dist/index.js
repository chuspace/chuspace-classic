import _regeneratorRuntime from "@babel/runtime/regenerator";

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

import { MODES } from './modes';
export var DEFAULT_MODE = 'auto';
export var loadMode =
/*#__PURE__*/
function () {
  var _ref = _asyncToGenerator(
  /*#__PURE__*/
  _regeneratorRuntime.mark(function _callee(mode) {
    var language;
    return _regeneratorRuntime.wrap(function _callee$(_context) {
      while (1) {
        switch (_context.prev = _context.next) {
          case 0:
            language = MODES.filter(function (language) {
              return language.mode && language.mode !== 'auto' && language.mode !== 'text' && language.mode !== 'javascript';
            }).find(function (language) {
              return language.mode === mode;
            });

            if (!language) {
              _context.next = 9;
              break;
            }

            if (!language.custom) {
              _context.next = 7;
              break;
            }

            _context.next = 5;
            return import("./custom/".concat(language.mode));

          case 5:
            _context.next = 9;
            break;

          case 7:
            _context.next = 9;
            return import("codemirror/mode/".concat(language.mode, "/").concat(language.mode));

          case 9:
            return _context.abrupt("return", language);

          case 10:
          case "end":
            return _context.stop();
        }
      }
    }, _callee);
  }));

  return function loadMode(_x) {
    return _ref.apply(this, arguments);
  };
}();
export { MODES };
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uL2xpYi9pbmRleC5qcyJdLCJuYW1lcyI6WyJNT0RFUyIsIkRFRkFVTFRfTU9ERSIsImxvYWRNb2RlIiwibW9kZSIsImxhbmd1YWdlIiwiZmlsdGVyIiwiZmluZCIsImN1c3RvbSJdLCJtYXBwaW5ncyI6Ijs7Ozs7O0FBR0EsU0FBU0EsS0FBVCxRQUFzQixTQUF0QjtBQUVBLE9BQU8sSUFBTUMsWUFBb0IsR0FBRyxNQUE3QjtBQUVQLE9BQU8sSUFBTUMsUUFBUTtBQUFBO0FBQUE7QUFBQTtBQUFBO0FBQUEsMkJBQUcsaUJBQU9DLElBQVA7QUFBQTtBQUFBO0FBQUE7QUFBQTtBQUFBO0FBQ2hCQyxZQUFBQSxRQURnQixHQUNVSixLQUFLLENBQUNLLE1BQU4sQ0FDOUIsVUFBQUQsUUFBUTtBQUFBLHFCQUFJQSxRQUFRLENBQUNELElBQVQsSUFBaUJDLFFBQVEsQ0FBQ0QsSUFBVCxLQUFrQixNQUFuQyxJQUE2Q0MsUUFBUSxDQUFDRCxJQUFULEtBQWtCLE1BQS9ELElBQXlFQyxRQUFRLENBQUNELElBQVQsS0FBa0IsWUFBL0Y7QUFBQSxhQURzQixFQUU5QkcsSUFGOEIsQ0FFekIsVUFBQ0YsUUFBRDtBQUFBLHFCQUE0QkEsUUFBUSxDQUFDRCxJQUFULEtBQWtCQSxJQUE5QztBQUFBLGFBRnlCLENBRFY7O0FBQUEsaUJBS2xCQyxRQUxrQjtBQUFBO0FBQUE7QUFBQTs7QUFBQSxpQkFNcEJBLFFBQVEsQ0FBQ0csTUFOVztBQUFBO0FBQUE7QUFBQTs7QUFBQTtBQUFBLG1CQVFWLDBCQUFtQkgsUUFBUSxDQUFDRCxJQUE1QixFQVJVOztBQUFBO0FBQUE7QUFBQTs7QUFBQTtBQUFBO0FBQUEsbUJBVVYsaUNBQTBCQyxRQUFRLENBQUNELElBQW5DLGNBQTJDQyxRQUFRLENBQUNELElBQXBELEVBVlU7O0FBQUE7QUFBQSw2Q0FhZkMsUUFiZTs7QUFBQTtBQUFBO0FBQUE7QUFBQTtBQUFBO0FBQUE7QUFBQSxHQUFIOztBQUFBLGtCQUFSRixRQUFRO0FBQUE7QUFBQTtBQUFBLEdBQWQ7QUFnQlAsU0FBU0YsS0FBVCIsInNvdXJjZXNDb250ZW50IjpbIi8vIEBmbG93XG5cbmltcG9ydCB0eXBlIHsgTGFuZ3VhZ2VUeXBlIH0gZnJvbSAnLi9tb2RlcydcbmltcG9ydCB7IE1PREVTIH0gZnJvbSAnLi9tb2RlcydcblxuZXhwb3J0IGNvbnN0IERFRkFVTFRfTU9ERTogc3RyaW5nID0gJ2F1dG8nXG5cbmV4cG9ydCBjb25zdCBsb2FkTW9kZSA9IGFzeW5jIChtb2RlOiBzdHJpbmcpID0+IHtcbiAgY29uc3QgbGFuZ3VhZ2U6ID9MYW5ndWFnZVR5cGUgPSBNT0RFUy5maWx0ZXIoXG4gICAgbGFuZ3VhZ2UgPT4gbGFuZ3VhZ2UubW9kZSAmJiBsYW5ndWFnZS5tb2RlICE9PSAnYXV0bycgJiYgbGFuZ3VhZ2UubW9kZSAhPT0gJ3RleHQnICYmIGxhbmd1YWdlLm1vZGUgIT09ICdqYXZhc2NyaXB0J1xuICApLmZpbmQoKGxhbmd1YWdlOiBMYW5ndWFnZVR5cGUpID0+IGxhbmd1YWdlLm1vZGUgPT09IG1vZGUpXG5cbiAgaWYgKGxhbmd1YWdlKSB7XG4gICAgbGFuZ3VhZ2UuY3VzdG9tXG4gICAgICA/IC8qICRGbG93Rml4TWUgKi9cbiAgICAgICAgYXdhaXQgaW1wb3J0KGAuL2N1c3RvbS8ke2xhbmd1YWdlLm1vZGV9YClcbiAgICAgIDogLyogJEZsb3dGaXhNZSAqL1xuICAgICAgICBhd2FpdCBpbXBvcnQoYGNvZGVtaXJyb3IvbW9kZS8ke2xhbmd1YWdlLm1vZGV9LyR7bGFuZ3VhZ2UubW9kZX1gKVxuICB9XG5cbiAgcmV0dXJuIGxhbmd1YWdlXG59XG5cbmV4cG9ydCB7IE1PREVTIH1cbiJdfQ==