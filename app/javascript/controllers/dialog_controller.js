// @flow

import { Controller } from 'stimulus'
import Dialog from 'helpers/dialog'

export default class extends Controller {
  connect() {
    this.dialog = new Dialog(this.element)
  }

  show() {
    this.dialog.show()
  }

  close() {
    this.dialog.hide()
  }
}
