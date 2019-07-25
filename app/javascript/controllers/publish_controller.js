// @flow

import { Controller } from 'stimulus'
import Dialog from 'helpers/dialog'

export default class extends Controller {
  connect() {
    const dialog = new Dialog(this.element)
    dialog.show()
  }
}
