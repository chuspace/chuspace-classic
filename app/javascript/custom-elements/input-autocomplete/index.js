// @flow

import { LitElement, customElement, html } from 'lit-element'

import autoComplete from '@tarekraafat/autocomplete.js'
import last from 'lodash/last'
import { render } from 'lit-html'
import without from 'lodash/without'

export default class InputAutocomplete extends LitElement {
  input: HTMLInputElement = this.querySelector('input')
  selectionsInput: HTMLInputElement = this.querySelector('#selections__input')
  selectionsContainer: HTMLElement = this.querySelector('.autocomplete__selections')
  container: HTMLElement = this.querySelector('.input__container')

  static get properties() {
    return {
      items: { type: Array, reflect: true },
      url: { type: String },
      keys: { types: String },
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
    this.renderItems()
    this.initAutocomplete()
  }

  isInvalid = (items: string) => /^[a-z0-9]+(?:-[a-z0-9]+)*$/.test(items) == false

  initAutocomplete = () => {
    if (this.autocompleteInstance) return

    this.autocompleteInstance = new autoComplete({
      data: {
        src: async () => {
          const source = await fetch(`${this.url}?q=${this.input.value}`)
          const data = await source.json()

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
      maxResults: 5,
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
          const inputValue = this.input.value.trim()

          if (this.isInvalid(inputValue)) return

          if (this.items.indexOf(inputValue) === -1) {
            item.setAttribute('tabindex', '1')
            item.innerHTML = `Not found. Create <span class='autocomplete__item__custom'>${inputValue}</span>`
            list && list.appendChild(item)
            item.addEventListener('click', (e: MouseEvent) => {
              const customTopic = item.querySelector('.autocomplete__item__custom')
              customTopic && this.add(customTopic.textContent)
              item.remove()
              this.input.value = ''
            })
          }
        }
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
    this.triggerChange()

    if (this.items.length === this.maxlength) {
      this.setAttribute('disabled', true)
      return
    }
  }

  renderItems() {
    this.selectionsContainer.innerHTML = ''

    this.items.forEach(label => {
      const spanNode = document.createElement('span')
      this.selectionsContainer.append(spanNode)

      render(this.renderItem(label), spanNode)
    })
  }

  triggerChange() {
    this.selectionsInput.value = this.items
    this.selectionsInput.onchange && this.selectionsInput.onchange()
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
        this.triggerChange()
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
