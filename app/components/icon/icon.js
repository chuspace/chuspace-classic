// @flow

import './styles.sass'

import { LitElement, customElement, svg } from 'lit-element'

import icons from './icons.json'

class SvgIcon extends LitElement {
  static get properties() {
    return {
      name: { type: String },
      width: { type: Number },
      height: { type: Number },
      fontsize: { type: String },
      color: { type: String },
      feather: { type: String }
    }
  }

  renderCustom = () =>
    new DOMParser()
      .parseFromString(
        `<svg
          xmlns="http://www.w3.org/2000/svg"
          width="${this.width}" height="${this.height}"
          viewBox="${`0 0 ${this.width} ${this.height}`}"
          fill="${this.color}"
        >
          ${icons[this.name]}
        </svg>`,
        'image/svg+xml'
      )
      .querySelector('svg')

  renderFeather = () =>
    new DOMParser()
      .parseFromString(
        `<svg
          xmlns="http://www.w3.org/2000/svg"
          width="${this.width}"
          height="${this.height}"
          viewBox="${`0 0 ${this.width} ${this.height}`}"
          fill="${this.color}"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
        >
          ${icons[this.name]}
        </svg>`,
        'image/svg+xml'
      )
      .querySelector('svg')

  constructor() {
    super()

    this.width = 20
    this.height = 20
    this.color = 'inherit'

    try {
      this.feather = JSON.parse(this.feather)
    } catch (e) {}
  }

  createRenderRoot() {
    return this
  }

  render() {
    return svg`
      ${this.feather ? this.renderFeather() : this.renderCustom()}
    `
  }
}

document.addEventListener('turbolinks:load', () => {
  if (!window.customElements.get('svg-icon')) {
    customElements.define('svg-icon', SvgIcon)
  }
})

export default SvgIcon
