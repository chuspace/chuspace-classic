// @flow

import * as Rails from 'rails-ujs'
import * as Turbolinks from 'turbolinks'

import { Controller } from 'stimulus'
import Editor from 'editor'
import debounce from 'lodash/debounce'

export default class extends Controller {
  static targets = ['editor']
  editor: any
  saving = false
  method = this.editorTarget.dataset.method
  url = this.editorTarget.dataset.url

  connect() {
    this.editor = new Editor({
      element: this.editorTarget,
      autoFocus: this.method === 'POST',
      editable: true,
      onChange: this.onChange,
      content: this.editorTarget.dataset.content || ''
    })
  }

  onChange = () => {
    if (!this.saving) this.save()
  }

  save() {
    this.saving = true
    const body = this.editor.getMarkdown()
    const title = this.editor.getTitle()

    fetch(this.url, {
      method: this.method,
      body: JSON.stringify({ post: { title, body } }),
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
          this.method = 'PATCH'
        }

        this.saving = false

        return response
      })
  }

  publish(e) {
    e.preventDefault()
    Rails.ajax({
      type: 'POST',
      url: e.target.dataset.url,
      data: `nickname=${this.inputNicknameTarget.value}`,
      success: data => this.resetErrors(),
      error: data => {
        if (data.errors && data.errors.length > 0) {
          this.resetErrors()
          this.setFormErrors(data.errors)
          return
        }
      }
    })
  }
}
