// @flow

import { LitElement, customElement, html } from 'lit-element'

import autoComplete from '@tarekraafat/autocomplete.js'
import last from 'lodash/last'
import without from 'lodash/without'

export default class ChuTopics extends LitElement {
  static get properties() {
    return {
      topics: { type: Array },
      autofocus: { type: Boolean },
      maxlength: { type: Number }
    }
  }

  createRenderRoot() {
    return this
  }

  async connectedCallback() {
    await super.connectedCallback()
    this.initAutocomplete()
  }

  initAutocomplete = () => {
    const input = this.querySelector('.chu-topics__input')
    if (this.autocompleteInstance) return

    this.autocompleteInstance = new autoComplete({
      data: {
        src: async () => {
          const source = await fetch(`/topics.json?q=${input.value}`)
          const data = await source.json()

          return data
        },
        key: ['name'],
        cache: false
      },
      placeHolder: 'Type to add upto 3 topics...',
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
          source.className = 'chu-topics__list arrow'
        },
        destination: this.querySelector('.chu-topics__input__container'),
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
        const item = document.createElement('li')
        const list = document.querySelector('.chu-topics__list')
        item.setAttribute('tabindex', '1')
        item.innerHTML = `Not found. Create <span class='chu-topics__topic__custom'>${input.value.trim()}</span>`
        list && list.appendChild(item)
        item.addEventListener('click', (e: MouseEvent) => {
          const customTopic = item.querySelector('.chu-topics__topic__custom')
          customTopic && this.add(customTopic.textContent)
          item.remove()
          input.value = ''
        })
      },
      onSelection: feedback => {
        this.add(feedback.selection.value.name)
        input.value = ''
        input.focus()
      }
    })
  }

  add(topic: string) {
    if (!topic) return
    this.topics = this.topics.concat([topic])

    if (this.topics.length >= this.maxlength) {
      const input = this.querySelector('input')
      input.setAttribute('disabled', true)
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
        this.topics = without(this.topics, last(this.topics))
        input.removeAttribute('disabled')
        break
      default:
        break
    }
  }

  remove(e: MouseEvent) {
    if (!(e.currentTarget instanceof HTMLElement)) {
      return
    }

    const topicNode = e.currentTarget.closest('.chu-topics__topic')

    if (topicNode) {
      const topic = topicNode.textContent.trim()
      const index = this.topics.indexOf(topic)

      if (index > -1) {
        this.topics = without(this.topics, topic)
      }

      const input = this.querySelector('.chu-topics__input')
      input && input.focus()
      input.removeAttribute('disabled')
    }
  }

  render() {
    return html`
      <label class="input__label mt-2" for="post_topics">Topics</label>
      <div class="chu-topics__input__container">
        <input class="chu-topics__input" name="post_topics" autocomplete="off" @keydown=${this.handleKeyDown} />
      </div>
      <div class="chu-topics__container mt-4">
        ${this.topics.map(
          tag =>
            html`<span class="chu-topics chu-topics__topic mr-2">
            ${tag} <svg-icon class='chu-topics__topic__icon' @click=${this.remove} name='x-circle' width='10' height='10' feather='true' color='none'>&#10005</svg-icon></span>
          `
        )}
      </div>
    `
  }
}

document.addEventListener('turbolinks:load', () => {
  if (!window.customElements.get('chu-topics')) {
    customElements.define('chu-topics', ChuTopics)
  }
})
