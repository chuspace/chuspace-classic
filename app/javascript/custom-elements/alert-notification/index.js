// @flow

import { LitElement, customElement, html } from 'lit-element'

export default class AlertNotification extends LitElement {
  static get properties() {
    return {
      level: { type: String },
      message: { type: String }
    }
  }

  connectedCallback() {
    super.connectedCallback()

    setTimeout(() => {
      this.classList.remove('fadeInDown')
      this.classList.add('fadeOutUp')
    }, 5000)
  }

  createRenderRoot() {
    return this
  }

  render() {
    return html`
      <div class="alert alert--${this.level}">
        <div class="p-4 ">
          ${this.message}
        </div>
      </div>
    `
  }
}

document.addEventListener('turbolinks:load', () => {
  if (!window.customElements.get('alert-notification')) {
    customElements.define('alert-notification', AlertNotification)
  }
})
