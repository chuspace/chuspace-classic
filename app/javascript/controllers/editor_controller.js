// @flow

import { Controller } from 'stimulus'
import Editor from 'editor'

// Import editor components

export default class extends Controller {
  editor: any

  connect () {
    this.editor = new Editor({
      element: this.element,
      autoFocus: true,
      editable: true,
      content: '<p>This is just a boring paragraph</p>'
    })
  }
}
