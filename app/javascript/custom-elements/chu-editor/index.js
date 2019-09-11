// @flow

import * as Rails from 'rails-ujs'

import { LitElement, customElement, html } from 'lit-element'

import ActioncableClient from 'helpers/actioncable-client'
import Editor from 'editor'
import debounce from 'lodash/debounce'
import readingTime from 'helpers/reading-time'

export default class ChuEditor extends LitElement {
  editor: Editor
  status: 'Saved'

  static get properties() {
    return {
      url: { type: String, reflect: true },
      id: { type: String },
      original: { type: String },
      content: { type: String },
      channel: { type: String },
      editable: { type: Boolean },
      imageProviderPath: { type: String },
      saving: { type: Boolean, reflect: true },
      autofocus: { type: Boolean }
    }
  }

  onRecieved = (data: any) => {
    this.saving = false
  }

  async connectedCallback() {
    await super.connectedCallback()

    this.editor = new Editor({
      element: this,
      autoFocus: this.autofocus,
      editable: this.editable,
      imageProviderPath: this.imageProviderPath,
      placeholder: 'Write your post',
      onChange: this.onChange,
      original: this.original,
      content: this.content || ''
    })
  }

  disconnectedCallback() {
    super.disconnectedCallback()

    if (ActioncableClient.subscribedTo('AutosaveChannel')) ActioncableClient.unsubscribe('AutosaveChannel')
    this.editor.destroy()

    window.onbeforeunload = null
  }

  updateStatuses() {
    const status = document.getElementById('editor-status')
    if (status) status.textContent = this.saving ? 'Saving...' : 'Saved'
  }

  updated = () => {
    if (this.editable && this.id) {
      window.onbeforeunload = () => (this.saving ? 'Are you sure you want to navigate away?' : null)

      this.updateStatuses()

      this.subscription = ActioncableClient.subscribe(
        {
          channel: this.channel,
          id: this.id
        },
        {
          received: this.onRecieved
        }
      )
    }
  }

  onChange = () => {
    if (this.saving) return

    this.saving = true

    if (this.id) {
      this.autosave()
    } else {
      this.create()
    }
  }

  get payload() {
    return {
      body: this.editor.content
    }
  }

  autosave = debounce(
    () => {
      this.subscription.send(this.payload)
    },
    500,
    { maxWait: 500 }
  )

  create = debounce(
    () => {
      fetch(this.url, {
        method: 'POST',
        body: JSON.stringify({ post: this.payload }),
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-TOKEN': Rails.csrfToken()
        }
      })
        .then(response => response.json())
        .then(async response => {
          if (response.redirect) {
            window.history.pushState(null, 'Edit', response.redirect)
            this.id = response.slug
            await this.requestUpdate()
            const header = document.getElementById('post_header')
            if (header) header.innerHTML = response.header
          }

          return response
        })
        .finally(() => (this.saving = false))
    },
    2000,
    { maxWait: 2000 }
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
