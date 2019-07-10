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

  get isPersisted() {
    return !!this.id
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

    window.onbeforeunload = () => (this.saving ? 'Are you sure you want to navigate away?' : null)

    if (this.isPersisted) this.updatePublishDialog()
  }

  disconnectedCallback() {
    super.disconnectedCallback()

    if (ActioncableClient.subscribedTo('AutosaveChannel')) ActioncableClient.unsubscribe('AutosaveChannel')
    this.editor.destroy()

    window.onbeforeunload = null
  }

  updatePublishDialog() {
    const dialog = document.querySelector('dialog')

    if (!dialog) return

    const title = dialog.querySelector('#title')
    const summary = dialog.querySelector('#summary')

    if (!title || !summary) return

    title.textContent = this.editor.title

    if (this.editor.summary) {
      summary.textContent = this.editor.summary || ''
      summary.classList.remove('summary__empty')
    } else {
      summary.textContent = "You haven't written a summary"
      summary.classList.add('summary__empty')
    }
  }

  updated = () => {
    if (this.isPersisted) {
      this.subscription = ActioncableClient.subscribe(
        {
          channel: 'AutosaveChannel',
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
    this.updatePublishDialog()
    this.saving = true

    if (this.isPersisted) {
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
    2000,
    { maxWait: 2000 }
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
        .then(response => {
          console.log(response)

          if (response.redirect) {
            window.history.pushState(null, 'Edit', response.redirect)
            this.id = response.slug
          }

          return response
        })
        .finally(() => (this.saving = false))
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
