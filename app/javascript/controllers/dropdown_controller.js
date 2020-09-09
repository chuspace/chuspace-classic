// @flow

import { Controller } from 'stimulus'

export default class extends Controller {
  initialize() {
    document.addEventListener('click', (e: Event) => {
      if (this.element && this.element.contains(e.target)) return
      else this.element.open = false
    })
  }

  disconnect() {
    this.element.open = false
  }
}
