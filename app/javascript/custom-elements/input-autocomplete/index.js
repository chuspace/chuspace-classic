// @flow

import { LitElement, customElement, html } from 'lit-element'

import autoComplete from '@tarekraafat/autocomplete.js'
import last from 'lodash/last'
import { render } from 'lit-html'
import without from 'lodash/without'

export default class InputAutocomplete extends LitElement {
  input: HTMLInputElement = this.querySelector('input')
  selectionsContainer: HTMLElement = this.querySelector('.autocomplete__selections')
  container: HTMLElement = this.querySelector('.input__dropdown__group')

  static get properties() {
    return {
      items: { type: Array },
      name: { type: String },
      url: { type: String },
      keys: { types: String },
      maxlength: { type: Number }
    }
  }

  constructor() {
    super()

    this.placeHolder = 'Type something...'
  }

  createRenderRoot() {
    return this
  }

  async connectedCallback() {
    await super.connectedCallback()
    this.renderItems()
    this.initAutocomplete()
  }

  isInvalid = (items: string) => /^[a-z0-9]+(?:-[a-z0-9]+)*$/.test(items) == false

  initAutocomplete = () => {
    if (this.autocompleteInstance) return

    this.autocompleteInstance = new autoComplete({
      data: {
        src: async () => {
          const query = this.input.value.trim()
          const source = await fetch(`${this.url}?q=${query}`)
          const data = await source.json()
          if (!data.find(item => item[this.keys] === query)) data.push({ name: query, custom: true })

          return data.filter(items => this.items.indexOf(items[this.keys]) === -1)
        },
        key: [this.keys],
        cache: false
      },
      placeHolder: this.placeholder,
      selector: () => this.input,
      threshold: 1,
      debounce: 300,
      searchEngine: 'strict',
      maxResults: 6,
      highlight: true,
      resultsList: {
        render: true,
        container: function(source) {
          source.removeAttribute('id')
          source.className = 'autocomplete__list arrow'
        },
        destination: this.container,
        position: 'beforeend',
        element: 'ul'
      },
      resultItem: {
        content: (data, source) => {
          const custom = `Not found. Create <span class='autocomplete__item__custom'>${this.input.value.trim()}</span>`
          source.innerHTML = data.value.custom ? custom : data.match
          source.removeAttribute('id')
        },
        element: 'li'
      },
      onSelection: feedback => {
        this.add(feedback.selection.value[this.keys])
        this.input.value = ''
        this.input.focus()
      }
    })
  }

  add(items: string) {
    if (!items) return
    if (this.items.indexOf(items) !== -1) return
    if (this.isInvalid(items)) return

    this.items = this.items.concat([items])

    this.renderItems()

    if (this.items.length === this.maxlength) {
      this.setAttribute('disabled', true)
    }

    this.input && this.input.focus()
  }

  renderItems() {
    this.selectionsContainer.innerHTML = ''

    this.items.forEach(label => {
      const spanNode = document.createElement('span')
      this.selectionsContainer.append(spanNode)

      render(this.renderItem(label), spanNode)
      const inputElement = document.createElement('input')
      inputElement.name = this.name
      inputElement.value = label
      inputElement.type = 'hidden'
      this.selectionsContainer.appendChild(inputElement)
    })
  }

  renderItem(label: string) {
    return html`
      <span class="autocomplete__item mr-2">
        ${label}
        <svg-icon class='autocomplete__item__icon' @click=${this.remove} name='x-circle' width='10' height='10' feather='true' color='none'>&#10005</svg-icon>
      </span>
    `
  }

  handleKeyDown(e: KeyboardEvent) {
    switch (e.keyCode) {
      case 13:
        e.preventDefault()
        break
      case 8:
        if (this.input.value) return
        this.items = without(this.items, last(this.items))
        this.removeAttribute('disabled')
        break
      default:
        break
    }
  }

  remove = (e: MouseEvent) => {
    if (!(e.currentTarget instanceof HTMLElement)) {
      return
    }

    const itemsNode = e.currentTarget.closest('.autocomplete__item')

    if (itemsNode) {
      const item = itemsNode.textContent.trim()
      const index = this.items.indexOf(item)

      if (index > -1) {
        this.items = without(this.items, item)
        this.renderItems()
      }

      this.input && this.input.focus()
      this.hasAttribute('disabled') && this.removeAttribute('disabled')
    }
  }
}

document.addEventListener('turbolinks:load', () => {
  if (!window.customElements.get('input-autocomplete')) {
    customElements.define('input-autocomplete', InputAutocomplete)
  }
})
