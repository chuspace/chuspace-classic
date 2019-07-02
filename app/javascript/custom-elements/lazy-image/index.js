// @flow

import { LitElement, customElement, html } from 'lit-element'

export default class LazyImage extends LitElement {
  static get properties() {
    return {
      src: { type: String },
      alt: { type: String },
      align: { type: String, reflect: true },
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

  setAlign = (e: Event) => {
    e.preventDefault()
    // $FlowFixMe
    this.align = e.currentTarget.dataset.align
    this.handleChange({ align: this.align, alt: this.alt })
  }

  onCaptionChange = (e: Event) => {
    // $FlowFixMe
    this.alt = e.target.value
    this.handleChange({ align: this.align, alt: this.alt })
  }

  render() {
    return html`
      <div class="image-container">
        ${this.editable
          ? html`
              <div class="image-toolbar">
                <svg-icon name="image-left" color="#fff" @click=${this.setAlign} data-align="left"></svg-icon>
                <svg-icon name="image-center" color="#fff" @click=${this.setAlign} data-align="middle"></svg-icon>
                <svg-icon name="image-right" color="#fff" @click=${this.setAlign} data-align="right"></svg-icon>
                <svg-icon name="image-full" color="#fff" @click=${this.setAlign} data-align="none"></svg-icon>
                <div class="tooltip-arrow"></div>
              </div>
            `
          : null}
        <img alt=${this.alt} src=${this.src} @click=${this.selectNode} />
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
