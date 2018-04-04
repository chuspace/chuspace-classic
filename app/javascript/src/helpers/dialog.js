import dialogPolyfill from 'dialog-polyfill'

export default class Dialog {
  constructor (props) {
    this.domNodeId = props.domNodeId
    this.dialog = this.register()
  }

  register () {
    const dialog = document.getElementById(this.domNodeId)
    if (typeof HTMLDialogElement !== 'function') {
      dialogPolyfill.registerDialog(dialog)
    }
    return dialog
  }

  hide () {
    if (!this.dialog.open) return
    this.dialog.close()
    document.body.classList.remove('dialog-open')
  }

  show () {
    if (this.dialog.open) {
      return
    }
    this.dialog.showModal()
    document.body.classList.add('dialog-open')
  }
}
