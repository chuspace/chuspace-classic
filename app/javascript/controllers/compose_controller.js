// @flow

import * as Rails from 'rails-ujs'

import { Controller } from 'stimulus'
import Editor from 'editor'

export default class extends Controller {
  static targets = ['editor']
  editor: any

  connect() {
    this.editor = new Editor({
      element: this.editorTarget,
      autoFocus: true,
      editable: true,
      content: this.editorTarget.dataset.content || ''
    })
  }

  saveDraft(e) {
    e.preventDefault()
    const body = this.editor.getMarkdown()
    const title = this.editor.getTitle()

    fetch(e.target.dataset.url, {
      method: 'POST',
      body: JSON.stringify({ post: { title, body } }),
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-TOKEN': Rails.csrfToken()
      }
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
