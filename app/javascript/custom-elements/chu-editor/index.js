// @flow

import * as Rails from 'rails-ujs'

import { LitElement, customElement, html } from 'lit-element'

import ActioncableClient from 'helpers/actioncable-client'
import Editor from 'editor'
import debounce from 'lodash/debounce'

export default class ChuEditor extends LitElement {
  editor: Editor

  static get properties() {
    return {
      url: { type: String, reflect: true },
      id: { type: String },
      method: { type: String, reflect: true },
      content: { type: String },
      saving: { type: Boolean, reflect: true },
      autofocus: { type: Boolean }
    }
  }

  onRecieved = (data: any) => {
    this.saving = false

    console.log(data)
  }

  onSubscribed = () => {
    console.log('connected')
  }

  async connectedCallback() {
    await super.connectedCallback()

    try {
      this.autofocus = JSON.parse(this.autofocus)
    } catch (e) {
      this.autofocus = false
    }

    this.editor = new Editor({
      element: this,
      autoFocus: this.autofocus,
      editable: true,
      placeholder: 'Write your post',
      onChange: this.onChange,
      content: this.content || ''
    })

    this.setPublishAttrs()
  }

  disconnectedCallback() {
    super.disconnectedCallback()

    ActioncableClient.unsubscribe('PostChannel')
    this.editor.destroy()
  }

  setPublishAttrs() {
    const dialog = document.querySelector('dialog')

    if (!dialog) return

    const title = dialog.querySelector('#title')
    const summary = dialog.querySelector('#summary')

    if (!title || !summary) return

    title.textContent = this.editor.getTitle()

    if (this.editor.getSummary()) {
      summary.textContent = this.editor.getSummary()
      summary.classList.remove('summary__empty')
    } else {
      summary.textContent = "You haven't written a summary"
      summary.classList.add('summary__empty')
    }
  }

  updated = () => {
    if (this.method === 'PATCH') {
      this.subscription = ActioncableClient.subscribe(
        {
          channel: 'PostChannel',
          slug: this.id
        },
        {
          connected: this.onSubscribed,
          received: this.onRecieved
        }
      )
    }
  }

  onChange = () => {
    this.setPublishAttrs()

    if (this.saving) return
    switch (this.method) {
      case 'POST':
        this.create()
        break

      default:
        this.autosave()
        break
    }
  }

  get payload() {
    return {
      blob: { body: this.editor.getMarkdown() }
    }
  }

  autosave = debounce(
    () => {
      this.saving = true
      this.subscription.send(this.payload)
    },
    250,
    { maxWait: 1000 }
  )

  create = debounce(
    () => {
      this.saving = true

      fetch(this.url, {
        method: this.method,
        body: JSON.stringify(this.payload),
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-TOKEN': Rails.csrfToken()
        }
      })
        .then(response => response.json())
        .then(response => {
          if (response.url) {
            window.history.pushState(null, 'Edit', response.redirect)
            this.url = response.url
            this.id = response.slug
            this.method = 'PATCH'
          }
          this.saving = false
          return response
        })
    },
    2000,
    { maxWait: 5000 }
  )

  createRenderRoot() {
    return this
  }
}

document.addEventListener('turbolinks:load', () => {
  if (!window.customElements.get('chu-editor')) {
    customElements.define('chu-editor', ChuEditor)
  }
})
