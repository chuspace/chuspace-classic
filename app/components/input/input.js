// @flow

import { LitElement, customElement, html } from 'lit-element'

import debounce from 'lodash/debounce'
import fetchClient from 'helpers/fetch-client'

const previousValues = new WeakMap()

class AutoValidateInput extends LitElement {
  input: HTMLInputElement = this.querySelector('input')

  static get properties() {
    return {
      url: { type: String }
    }
  }

  constructor() {
    super()

    this.boundCheck = debounce(this.check.bind(this), 300)

    if (this.input instanceof HTMLInputElement) {
      this.inputContainer = this.querySelector('.input__container')
      this.inputError = this.inputContainer.querySelector('.input__error')

      if (!this.inputError) {
        this.inputError = document.createElement('span')
        this.inputError.className = 'input__error'
        this.inputContainer.appendChild(this.inputError)
      }

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
      value: this.input.value
    }

    const id = Object.entries(body) ? Object.entries(body).join(':') : null
    if (id && id === previousValues.get(this.input)) return
    previousValues.set(this.input, id)

    if (!this.input.value.trim()) {
      this.setError('')
      return
    }

    fetchClient
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
    this.inputError.textContent = text

    if (text) {
      this.inputContainer.classList.add('input__container--invalid')
    } else {
      this.inputContainer.classList.remove('input__container--invalid')
    }
  }

  render() {
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
