// @flow

import './image.sass'

import { LitElement, customElement, html } from 'lit-element'

import LazyLoad from 'vanilla-lazyload'

class LazyImage extends LitElement {
  static get properties() {
    return {
      src: { type: String },
      align: { type: String },
      alt: { type: String },
      width: { type: Number },
      isSelected: { type: Boolean }
    }
  }

  connectedCallback() {
    super.connectedCallback()

    setTimeout(() => {
      document.lazyLoadInstance.update()
    }, 1)
  }

  createRenderRoot() {
    return this
  }

  render() {
    const imageUrl = this.src
    const figFloat = this.align === 'left' || this.align === 'right' ? this.align : 'none'
    let figMargin = '0em auto'

    if (this.align === 'left') {
      figMargin = '1em 1em 1em 0px'
    }

    if (this.align === 'right') {
      figMargin = '1em 0px 1em 1em'
    }

    const figWidth = this.align === 'full' ? '100%' : `${this.width}%`

    return html`
      <img
        alt=${this.alt}
        class="lazy"
        data-src=${imageUrl}
        style="width: ${figWidth}; margin: ${figMargin}; float: ${figFloat}"
      />
      <figcaption contentEditable="false">
        <input
          type="text"
          @change=${e => this.handleAltChange(e.target.value)}
          class="input input--slim input--borderless text-center text-sm font-headings"
          autofocus=${this.isSelected}
          value=${this.alt}
          maxlength=${70}
          placeholder="Click to enter caption"
        />
      </figcaption>
    `
  }
}

document.addEventListener('turbolinks:load', () => {
  if (document && !document.lazyLoadInstance) {
    document.lazyLoadInstance = new LazyLoad({
      elements_selector: 'lazy-image img',
      load_delay: 0
    })
  }

  if (!window.customElements.get('lazy-image')) {
    customElements.define('lazy-image', LazyImage)
  }
})

export default LazyImage
