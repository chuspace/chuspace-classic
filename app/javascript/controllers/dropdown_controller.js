// @flow

import 'tether-drop/dist/css/drop-theme-arrows-bounce.css'

import { Controller } from 'stimulus'
import Drop from 'tether-drop'

export default class extends Controller {
  static targets = ['content', 'opener']

  dropInstance = null

  connect() {
    this.dropInstance = new Drop({
      target: this.openerTarget,
      content: this.contentTarget.innerHTML,
      classes: 'drop-theme-arrows-bounce drop-hero',
      position: 'bottom center',
      constrainToWindow: false,
      constrainToScrollParent: false,
      openOn: 'click'
    })
  }

  disconnect() {
    this.dropInstance && this.dropInstance.remove()
  }
}
