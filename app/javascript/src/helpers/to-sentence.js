const arrayToSentence = arr => {
  if (!Array.isArray(arr)) {
    throw new TypeError(
      'Expected an array, but got a non-array value ' + arr + '.'
    )
  }

  if (arr.length === 0) return ''
  if (arr.length === 1) return arr[0]

  return arr.slice(0, -1).join(', ') + ' and ' + arr[arr.length - 1]
}

export default arrayToSentence
