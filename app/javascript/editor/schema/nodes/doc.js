// @flow

import { Node } from 'editor/base'

export default class Doc extends Node {
  name = 'doc'

  get schema() {
    return {
      content: this.content
    }
  }

  get content() {
    let content = 'heading block+'

    switch (this.editor.options.mode) {
      case 'contribution':
        content = 'block+'
        break
      default:
        break
    }

    return content
  }
}
