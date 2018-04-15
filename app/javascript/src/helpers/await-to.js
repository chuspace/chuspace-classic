const awaitTo = promise =>
  promise.then(response => [null, response]).catch(err => [err])

export default awaitTo
