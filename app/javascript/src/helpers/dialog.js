// @flow

import 'dialog-polyfill/dialog-polyfill.css'

import dialogPolyfill from 'dialog-polyfill'

export default class Dialog {
  dialog: typeof window.HTMLDialogElement

  constructor (dialogElement: HTMLElement) {
    this.dialog = dialogElement
    if (typeof HTMLDialogElement !== 'function') {
      dialogPolyfill.registerDialog(this.dialog)
    }
  }

  hide () {
    if (!this.dialog.open) return
    this.dialog.close()
    document.body && document.body.classList.remove('dialog-open')
  }

  show () {
    if (this.dialog.open) return
    this.dialog.showModal()
    document.body && document.body.classList.add('dialog-open')
  }
}
