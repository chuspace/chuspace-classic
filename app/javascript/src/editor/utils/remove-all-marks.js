export default change => {
  const { value } = change
  if (value.marks) {
    value.marks.forEach(mark => {
      change.removeMark(mark)
    })
  }

  return change
}
