// @flow

import './styles.sass'

import { LitElement, customElement, svg } from 'lit-element'

class TooltipArrow extends LitElement {
  static get properties() {
    return {
      direction: { type: String },
      color: { type: Number }
    }
  }

  createRenderRoot() {
    return this
  }
}

if (!window.customElements.get('tooltip-arrow')) {
  customElements.define('tooltip-arrow', TooltipArrow)
}

export default TooltipArrow
