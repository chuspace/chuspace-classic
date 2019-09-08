// @flow

import { LitElement, customElement, html } from 'lit-element'

const ACCEPTED_IMAGES = ['image/png', 'image/jpg', 'image/jpeg', 'image/gif']

export default class DropImage extends LitElement {
  static get properties() {
    return {
      url: { type: String },
      hint: { type: String },
      errors: { type: String },
      param: { type: String }
    }
  }

  async connectedCallback() {
    await super.connectedCallback()

    this.input = this.querySelector('#drop_input')
    this.image = this.querySelector('#drop_preview')

    this.addEventListener('click', this.handleClick)
    this.addEventListener('dragover', this.handleDrag)
    this.addEventListener('drop', this.handleDrop)
    this.input.addEventListener('change', this.handleChange)
  }

  disconnectedCallback() {
    super.disconnectedCallback()

    this.removeEventListener('click', this.handleClick)
    this.removeEventListener('dragover', this.handleDrag)
    this.removeEventListener('drop', this.handleDrop)
    this.input.removeEventListener('change', this.handleChange)
  }

  handleDrag = (event: Event) => event.preventDefault()

  handleDrop = (event: DropImage) => {
    event.preventDefault()

    const image = event.dataTransfer.files[0]
    this.insert(image)
    this.input.files = event.dataTransfer.files
  }

  handleChange = (event: Event) => {
    /* $FlowFixMe */
    const image = event.target.files[0]
    this.insert(image)
  }

  insert = (image: File) => {
    if (ACCEPTED_IMAGES.includes(image.type)) {
      const reader = new FileReader()

      reader.readAsDataURL(image)
      reader.onload = file => {
        /* $FlowFixMe */
        this.url = file.target.result
      }
    }
  }

  handleClick = () => this.input.click()

  createRenderRoot() {
    return this
  }

  render() {
    return html`
      ${this.url
        ? html`
            <img class="avatar avatar--thumb" id="drop_preview" src=${this.url} />
          `
        : ''}

      <input id="drop_input" accept="image/*" type="file" name="${this.param}" class="hidden" />
      <span class="input__hint avatar__uploader__hint ${this.url ? '' : 'avatar__uploader__hint__blank'}">
        ${this.hint}
      </span>
      ${this.url
        ? null
        : html`
            <span class="input__error text-red block">${this.errors}</span>
          `}
    `
  }
}

document.addEventListener('turbolinks:load', () => {
  if (!window.customElements.get('drop-image')) {
    customElements.define('drop-image', DropImage)
  }
})
