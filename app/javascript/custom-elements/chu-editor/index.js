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
      content: { type: String },
      editable: { type: Boolean },
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

    this.editor = new Editor({
      element: this,
      autoFocus: this.autofocus,
      editable: this.editable,
      placeholder: 'Write your post',
      onChange: this.onChange,
      content: this.content || ''
    })

    if (this.id) this.updatePublishDialog()
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

    const title = dialog.querySelectorAll('#post_title')
    const summary = dialog.querySelectorAll('#post_summary')
    const body = dialog.querySelector('#post_body')

    if (!title || !summary || !body) return

    title.forEach(titleNode => {
      if (titleNode instanceof HTMLInputElement) titleNode.value = this.editor.title
      if (titleNode instanceof HTMLHeadingElement) titleNode.textContent = this.editor.title
    })

    body.textContent = this.editor.content

    summary.forEach(summaryNode => {
      if (summaryNode instanceof HTMLInputElement) summaryNode.value = this.editor.summary
      if (summaryNode instanceof HTMLHeadingElement) {
        if (this.editor.summary) {
          summaryNode.textContent = this.editor.summary || ''
          summaryNode.classList.remove('summary__empty')
        } else {
          summaryNode.textContent = "You haven't written a summary"
          summaryNode.classList.add('summary__empty')
        }
      }
    })
  }

  updateStatuses() {
    const status = document.getElementById('editor-status')
    if (status) status.textContent = this.saving ? 'Saving...' : 'Saved'
  }

  updated = () => {
    if (this.editable && this.id) {
      window.onbeforeunload = () => (this.saving ? 'Are you sure you want to navigate away?' : null)

      this.updateStatuses()
      if (this.editor) this.updatePublishDialog()

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
