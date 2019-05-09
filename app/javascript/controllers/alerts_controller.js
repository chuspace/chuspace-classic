// @flow

import { Controller } from 'stimulus'

export default class extends Controller {
  connect() {
    if (this.element.childElementCount > 0) {
      setTimeout(() => {
        this.element.classList.add('bounceOutRight')
      }, 2000)
    }
  }
}
