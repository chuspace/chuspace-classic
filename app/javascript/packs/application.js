import { renderReact } from '../utils/hypernova-nerv'
import Counter from '../counter'
import HelloReact from '../hello_react'

console.log('Hello world')

document.addEventListener('DOMContentLoaded', () => {
  renderReact('Counter', Counter)
  renderReact('HelloReact', HelloReact)
})
