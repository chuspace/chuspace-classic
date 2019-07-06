// @flow

import { LitElement, customElement, html } from 'lit-element'

import Dialog from 'helpers/dialog'

export default class DialogOpener extends LitElement {
  static get properties() {
    return {
      target: { type: String }
    }
  }

  connectedCallback() {
    super.connectedCallback()

    this.dialogElement = document.getElementById(this.target)
    this.dialog = new Dialog(this.dialogElement)
    console.log(this.attributes)
    this.addEventListener('click', this.open)

    this.dialogElement.querySelector('svg-icon').addEventListener('click', this.close)
  }

  open = (e: MouseEvent) => {
    e.preventDefault()
    this.dialog.show()
  }

  close = (e: MouseEvent) => {
    e.preventDefault()
    this.dialog.hide()
  }

  createRenderRoot() {
    return this
  }
}

document.addEventListener('turbolinks:load', () => {
  if (!window.customElements.get('dialog-opener')) {
    customElements.define('dialog-opener', DialogOpener)
  }
})
