// @flow

import 'lazysizes/plugins/blur-up/ls.blur-up'

import { LitElement, customElement, html } from 'lit-element'

import lazySizes from 'lazysizes'
import queryString from 'query-string'

lazySizes.cfg.lazyClass = 'lazy'
lazySizes.cfg.blurupMode = 'auto'

export default class LazyImage extends LitElement {
  static get properties() {
    return {
      src: { type: String },
      alt: { type: String },
      editable: { type: String }
    }
  }

  connectedCallback() {
    super.connectedCallback()

    try {
      this.alt = JSON.parse(this.alt) || ''
    } catch (e) {}

    try {
      this.editable = JSON.parse(this.editable)
    } catch (e) {
      this.editable = false
    }

    document.addEventListener('click', (e: MouseEvent) => {
      const el = e.target
      if (this && this.contains(el)) return
      this.classList.remove('selected')
    })
  }

  selectNode = () => {
    if (this.editable) {
      this.classList.toggle('selected')
    }
  }

  createRenderRoot() {
    return this
  }

  onCaptionChange = (e: Event) => {
    // $FlowFixMe
    this.alt = e.target.value
    this.handleChange({ alt: this.alt })
  }

  render() {
    const srcImage = `${this.src}?${queryString.stringify({
      quality: 100,
      width: 800
    })}`

    const placeholderImage = `${this.src}?${queryString.stringify({
      quality: 1,
      width: 800
    })}`

    return html`
      <div class="image-container">
        <img
          alt=${this.alt}
          data-lowsrc=${placeholderImage}
          data-src=${srcImage}
          data-sizes="auto"
          @click=${this.selectNode}
          class="lazy"
        />
        ${this.editable
          ? html`<figcaption contentEditable="false">
          <input
            type="text"
            @change=${this.onCaptionChange}
            class="input input--slim input--borderless text-center text-sm font-headings"
            value=${this.alt}
            maxlength=${70}
            placeholder="Click to enter caption"
          />
        </div>
      </figcaption>`
          : null}
      </div>
    `
  }
}

document.addEventListener('turbolinks:load', () => {
  if (!window.customElements.get('lazy-image')) {
    customElements.define('lazy-image', LazyImage)
  }
})
