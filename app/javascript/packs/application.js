import { renderReact } from '../utils/hypernova-nerv'
import Counter from '../counter'
import HelloReact from '../hello_react'

document.addEventListener('DOMContentLoaded', () => {
  renderReact('counter', Counter)
  renderReact('hello_react', HelloReact)
})
