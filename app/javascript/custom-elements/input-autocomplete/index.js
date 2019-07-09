// @flow

import { LitElement, customElement, html } from 'lit-element'

import autoComplete from '@tarekraafat/autocomplete.js'
import last from 'lodash/last'
import without from 'lodash/without'

export default class InputAutocomplete extends LitElement {
  static get properties() {
    return {
      items: { type: Array },
      url: { type: String },
      autofocus: { type: Boolean },
      label: { types: String },
      keys: { types: String },
      placeholder: { type: String },
      hint: { type: String },
      maxlength: { type: Number },
      noresults: { type: Boolean }
    }
  }

  constructor() {
    super()

    this.placeHolder = 'Type something...'
    this.noresults = false
  }

  createRenderRoot() {
    return this
  }

  async connectedCallback() {
    await super.connectedCallback()
    this.initAutocomplete()
  }

  isInvalid = (items: string) => /^[a-z0-9]+(?:-[a-z0-9]+)*$/.test(items) == false

  initAutocomplete = () => {
    const input = this.querySelector('.autocomplete__input')
    if (this.autocompleteInstance) return

    this.autocompleteInstance = new autoComplete({
      data: {
        src: async () => {
          const source = await fetch(`${this.url}?q=${input.value}`)
          const data = await source.json()

          return data.filter(items => this.items.indexOf(items[this.keys]) === -1)
        },
        key: [this.keys],
        cache: false
      },
      placeHolder: this.placeholder,
      selector: () => input,
      threshold: 1,
      debounce: 300,
      searchEngine: 'strict',
      maxResults: 5,
      highlight: true,
      resultsList: {
        render: true,
        container: function(source) {
          source.removeAttribute('id')
          source.className = 'autocomplete__list arrow'
        },
        destination: this.querySelector('.autocomplete__container'),
        position: 'beforeend',
        element: 'ul'
      },
      resultItem: {
        content: function(data, source) {
          source.innerHTML = data.match
          source.removeAttribute('id')
        },
        element: 'li'
      },
      noResults: () => {
        if (this.noresults) {
          const item = document.createElement('li')
          const list = this.querySelector('.autocomplete__list')
          const inputValue = input.value.trim()

          if (this.isInvalid(inputValue)) return

          if (this.items.indexOf(inputValue) === -1) {
            item.setAttribute('tabindex', '1')
            item.innerHTML = `Not found. Create <span class='autocomplete__item__custom'>${inputValue}</span>`
            list && list.appendChild(item)
            item.addEventListener('click', (e: MouseEvent) => {
              const customTopic = item.querySelector('.autocomplete__item__custom')
              customTopic && this.add(customTopic.textContent)
              item.remove()
              input.value = ''
            })
          }
        }
      },
      onSelection: feedback => {
        this.add(feedback.selection.value[this.keys])
        input.value = ''
        input.focus()
      }
    })
  }

  add(items: string) {
    if (!items) return
    if (this.items.indexOf(items) !== -1) return
    if (this.isInvalid(items)) return

    this.items = this.items.concat([items])

    if (this.items.length === this.maxlength) {
      const input = this.querySelector('input')
      this.setAttribute('disabled', true)
      return
    }
  }

  handleKeyDown(e: KeyboardEvent) {
    const input = this.querySelector('input')
    switch (e.keyCode) {
      case 13:
        e.preventDefault()
        break
      case 8:
        if (input.value) return
        this.items = without(this.items, last(this.items))
        this.removeAttribute('disabled')
        break
      default:
        break
    }
  }

  remove(e: MouseEvent) {
    if (!(e.currentTarget instanceof HTMLElement)) {
      return
    }

    const itemsNode = e.currentTarget.closest('.autocomplete__item')

    if (itemsNode) {
      const items = itemsNode.textContent.trim()
      const index = this.items.indexOf(items)

      if (index > -1) {
        this.items = without(this.items, items)
      }

      const input = this.querySelector('.autocomplete__input')
      input && input.focus()
      this.hasAttribute('disabled') && this.removeAttribute('disabled')
    }
  }

  render() {
    return html`
      <div class="form_field__container">
        <div class="input__container" data-label="${this.label}">
          <div class="autocomplete__container mt-4">
            ${this.items.map(
              tag =>
                html`<span class="autocomplete__item mr-2">
            ${tag} <svg-icon class='autocomplete__item__icon' @click=${this.remove} name='x-circle' width='10' height='10' feather='true' color='none'>&#10005</svg-icon></span>
          `
            )}
            <div class="autocomplete__container relative">
              <input class="autocomplete__input" autocomplete="off" @keydown=${this.handleKeyDown} />
            </div>
          </div>
        </div>
        ${this.hint
          ? html`
              <span class="input__hint">${this.hint}</span>
            `
          : ''}
      </div>
    `
  }
}

document.addEventListener('turbolinks:load', () => {
  if (!window.customElements.get('input-autocomplete')) {
    customElements.define('input-autocomplete', InputAutocomplete)
  }
})
