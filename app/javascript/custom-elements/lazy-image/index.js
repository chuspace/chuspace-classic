// @flow

import 'lazysizes/plugins/blur-up/ls.blur-up'

import { LitElement, customElement, html } from 'lit-element'

export default class LazyImage extends LitElement {
  static get properties() {
    return {
      src: { type: String },
      alt: { type: String },
      editable: { type: Boolean }
    }
  }

  connectedCallback() {
    super.connectedCallback()

    try {
      this.alt = JSON.parse(this.alt) || ''
    } catch (e) {}

    if (this.handleChange) this.setAttribute('editable', true)
  }

  createRenderRoot() {
    return this
  }

  onCaptionChange = (e: Event) => {
    // $FlowFixMe
    this.alt = e.target.value
    this.editable && this.handleChange({ alt: this.alt })
  }

  render() {
    return html`
      <figure class="image__container">
        <img alt=${this.alt} title=${this.alt} data-src="${this.src}" data-sizes="auto" class="lazy" />
        ${
          this.editable
            ? html`
                <figcaption contentEditable="false">
                  <input
                    type="text"
                    @change=${this.onCaptionChange}
                    class="input input--borderless p-0 italic text-center text-sm font-headings"
                    value=${this.alt}
                    maxlength=${70}
                    placeholder="Click to enter caption (optional)"
                  />
                </figcaption>
              `
            : this.alt
            ? html`
                <figcaption>${this.alt}</figcaption>
              `
            : null
        }
        </figcaption>
      </figure>
    `
  }
}

document.addEventListener('turbolinks:load', () => {
  if (!window.customElements.get('lazy-image')) {
    customElements.define('lazy-image', LazyImage)
  }
})
