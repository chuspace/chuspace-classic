// @flow

import './image.sass'

import { LitElement, customElement, html } from 'lit-element'

import LazyLoad from 'vanilla-lazyload'

class LazyImage extends LitElement {
  static get properties() {
    return {
      src: { type: String },
      alt: { type: String },
      align: { type: String, reflect: true }
    }
  }

  connectedCallback() {
    super.connectedCallback()

    try {
      this.alt = JSON.parse(this.alt) || ''
    } catch (e) {}

    setTimeout(() => {
      document.lazyLoadInstance.update()
    }, 1)

    document.addEventListener('click', (e: MouseEvent) => {
      const el = e.target
      if (this && this.contains(el)) return
      this.classList.remove('selected')
    })
  }

  selectNode = () => {
    this.classList.toggle('selected')
  }

  createRenderRoot() {
    return this
  }

  setAlign = (e: Event) => {
    e.preventDefault()
    // $FlowFixMe
    this.align = e.currentTarget.dataset.align
  }

  updated() {
    this.handleChange({ align: this.align, alt: this.alt })
  }

  // $FlowFixMe
  onCaptionChange = (e: Event) => (this.alt = e.target.value)

  render() {
    return html`
      <div class="image-container">
        <div class="image-toolbar">
          <svg-icon name="image-left" color="#fff" @click=${this.setAlign} data-align='left'></svg-icon>
          <svg-icon name="image-center" color="#fff" @click=${this.setAlign} data-align='middle'></svg-icon>
          <svg-icon name="image-right" color="#fff" @click=${this.setAlign} data-align='right'></svg-icon>
          <svg-icon name="image-full" color="#fff" @click=${this.setAlign} data-align='none'></svg-icon>
          <tooltip-arrow></tooltip-arrow>
        </div>
        <img
          alt=${this.alt}
          class="lazy"
          data-src=${this.src}
          @click=${this.selectNode}
        />
        <figcaption contentEditable="false">
          <input
            type="text"
            @change=${this.onCaptionChange}
            class="input input--slim input--borderless text-center text-sm font-headings"
            value=${this.alt}
            maxlength=${70}
            placeholder="Click to enter caption"
          />
        </div>
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
