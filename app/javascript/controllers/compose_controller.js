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
      content: '<p>This is just a boring paragraph</p>'
    })
  }

  saveDraft(e) {
    e.preventDefault()
    const html = this.editor.getMarkdown()
    console.log(this.data.get('url'))
    Rails.ajax({
      type: 'POST',
      url: e.target.dataset.url,
      data: `body=${html}&status=draft`,
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
