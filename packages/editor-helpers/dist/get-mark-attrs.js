function _toConsumableArray(arr) { return _arrayWithoutHoles(arr) || _iterableToArray(arr) || _nonIterableSpread(); }

function _nonIterableSpread() { throw new TypeError("Invalid attempt to spread non-iterable instance"); }

function _iterableToArray(iter) { if (Symbol.iterator in Object(iter) || Object.prototype.toString.call(iter) === "[object Arguments]") return Array.from(iter); }

function _arrayWithoutHoles(arr) { if (Array.isArray(arr)) { for (var i = 0, arr2 = new Array(arr.length); i < arr.length; i++) { arr2[i] = arr[i]; } return arr2; } }

export default function (state, type) {
  var _state$selection = state.selection,
      from = _state$selection.from,
      to = _state$selection.to;
  var marks = [];
  state.doc.nodesBetween(from, to, function (node) {
    marks = [].concat(_toConsumableArray(marks), _toConsumableArray(node.marks));
  });
  var mark = marks.find(function (markItem) {
    return markItem.type.name === type.name;
  });

  if (mark) {
    return mark.attrs;
  }

  return {};
}
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uL2xpYi9nZXQtbWFyay1hdHRycy5qcyJdLCJuYW1lcyI6WyJzdGF0ZSIsInR5cGUiLCJzZWxlY3Rpb24iLCJmcm9tIiwidG8iLCJtYXJrcyIsImRvYyIsIm5vZGVzQmV0d2VlbiIsIm5vZGUiLCJtYXJrIiwiZmluZCIsIm1hcmtJdGVtIiwibmFtZSIsImF0dHJzIl0sIm1hcHBpbmdzIjoiOzs7Ozs7OztBQUFBLGVBQWUsVUFBU0EsS0FBVCxFQUFnQkMsSUFBaEIsRUFBc0I7QUFBQSx5QkFDZEQsS0FBSyxDQUFDRSxTQURRO0FBQUEsTUFDM0JDLElBRDJCLG9CQUMzQkEsSUFEMkI7QUFBQSxNQUNyQkMsRUFEcUIsb0JBQ3JCQSxFQURxQjtBQUVuQyxNQUFJQyxLQUFLLEdBQUcsRUFBWjtBQUVBTCxFQUFBQSxLQUFLLENBQUNNLEdBQU4sQ0FBVUMsWUFBVixDQUF1QkosSUFBdkIsRUFBNkJDLEVBQTdCLEVBQWlDLFVBQUFJLElBQUksRUFBSTtBQUN2Q0gsSUFBQUEsS0FBSyxnQ0FBT0EsS0FBUCxzQkFBaUJHLElBQUksQ0FBQ0gsS0FBdEIsRUFBTDtBQUNELEdBRkQ7QUFJQSxNQUFNSSxJQUFJLEdBQUdKLEtBQUssQ0FBQ0ssSUFBTixDQUFXLFVBQUFDLFFBQVE7QUFBQSxXQUFJQSxRQUFRLENBQUNWLElBQVQsQ0FBY1csSUFBZCxLQUF1QlgsSUFBSSxDQUFDVyxJQUFoQztBQUFBLEdBQW5CLENBQWI7O0FBRUEsTUFBSUgsSUFBSixFQUFVO0FBQ1IsV0FBT0EsSUFBSSxDQUFDSSxLQUFaO0FBQ0Q7O0FBRUQsU0FBTyxFQUFQO0FBQ0QiLCJzb3VyY2VzQ29udGVudCI6WyJleHBvcnQgZGVmYXVsdCBmdW5jdGlvbihzdGF0ZSwgdHlwZSkge1xuICBjb25zdCB7IGZyb20sIHRvIH0gPSBzdGF0ZS5zZWxlY3Rpb25cbiAgbGV0IG1hcmtzID0gW11cblxuICBzdGF0ZS5kb2Mubm9kZXNCZXR3ZWVuKGZyb20sIHRvLCBub2RlID0+IHtcbiAgICBtYXJrcyA9IFsuLi5tYXJrcywgLi4ubm9kZS5tYXJrc11cbiAgfSlcblxuICBjb25zdCBtYXJrID0gbWFya3MuZmluZChtYXJrSXRlbSA9PiBtYXJrSXRlbS50eXBlLm5hbWUgPT09IHR5cGUubmFtZSlcblxuICBpZiAobWFyaykge1xuICAgIHJldHVybiBtYXJrLmF0dHJzXG4gIH1cblxuICByZXR1cm4ge31cbn1cbiJdfQ==