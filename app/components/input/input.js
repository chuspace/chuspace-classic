// @flow

import { LitElement, customElement, html, property } from 'lit-element'

import debounce from 'lodash/debounce'
import httpClient from 'helpers/fetch-client'

const previousValues = new WeakMap()

class AutoValidateInput extends LitElement {
  name: string = 'value'
  status: string = 'ready'
  input: HTMLInputElement = this.querySelector('input')

  static get properties() {
    return {
      name: { type: String },
      url: { type: String },
      status: { type: String, reflect: true }
    }
  }

  constructor() {
    super()

    this.boundCheck = debounce(this.check.bind(this), 300)

    if (this.input instanceof HTMLInputElement) {
      this.inputError = this.querySelector('.input__error')
      this.defaultErrorText = this.inputError.textContent
      this.input.addEventListener('change', this.boundCheck)
      this.input.addEventListener('input', this.boundCheck)
    }
  }

  disconnectedCallback() {
    if (this.input) {
      this.input.removeEventListener('change', this.boundCheck)
      this.input.removeEventListener('input', this.boundCheck)
      this.input.setCustomValidity('')
    }
  }

  check() {
    if (!this.url) {
      throw new Error('missing src')
    }

    const body = {
      [this.name]: this.input.value
    }

    const id = Object.entries(body) ? Object.entries(body).join(':') : null
    if (id && id === previousValues.get(this.input)) return
    previousValues.set(this.input, id)

    if (!this.input.value.trim()) {
      this.setError('')
      return
    }

    httpClient
      .post({
        url: this.url,
        body
      })
      .then(response => {
        if (!response.ok) {
          if (response.status === 422) {
            return Promise.reject(response.text())
          } else {
            return Promise.reject('Something went wrong!')
          }
        }

        return response
      })
      .then(response => {
        this.setError('')
      })
      .catch(async error => {
        const text = await error

        this.setError(text)
      })
  }

  setError(text: string) {
    this.inputError.textContent = text || this.defaultErrorText
    if (text) {
      this.status = 'invalid'
    } else {
      this.status = 'ready'
    }
  }

  render() {
    this.check()

    return html`
      <div>
        <slot></slot>
      </div>
    `
  }
}

document.addEventListener('turbolinks:load', () => {
  if (!window.customElements.get('input-check')) {
    customElements.define('input-check', AutoValidateInput)
  }
})

export default AutoValidateInput
