// @flow

import { Controller } from 'stimulus'
import Editor from 'editor'

export default class extends Controller {
  connect () {
    this.editor = new Editor({
      element: this.element,
      onChange: this.onChange
    })
  }

  onChange = (content: any) => console.log(content)
}
