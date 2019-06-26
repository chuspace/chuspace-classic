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
      selected: { type: Boolean }
    }
  }
  constructor() {
    super()

    this.selected = false
  }

  connectedCallback() {
    super.connectedCallback()

    try {
      this.alt = JSON.parse(this.alt) || ''
    } catch (e) {}

    setTimeout(() => {
      document.lazyLoadInstance.update()

      this.containerNode = this.querySelector('.image-container')
    }, 1)

    document.addEventListener('click', (e: MouseEvent) => {
      const el = e.target
      if (this.containerNode && this.contains(el)) return
      this.containerNode.classList.remove('selected')
    })
  }

  selectNode = () => {
    this.containerNode.classList.toggle('selected')
  }

  createRenderRoot() {
    return this
  }

  setAlign = (e, direction) => {
    e.preventDefault()
    this.align = direction
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
      <div class="image-container" style="width: ${figWidth}; margin: ${figMargin}; float: ${figFloat}">
        <div class="image-toolbar">
          <svg-icon name="image-left" color="#fff" @click=${e => this.setAlign(e, 'left')}></svg-icon>
          <svg-icon name="image-center" color="#fff"></svg-icon>
          <svg-icon name="image-right" color="#fff"></svg-icon>
          <svg-icon name="image-full" color="#fff"></svg-icon>
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
            @change=${e => this.handleAltChange(e.target.value)}
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
