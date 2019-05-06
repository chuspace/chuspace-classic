// @flow

import { Node } from 'prosemirror-model'

export default class Element {
  options: any
  name: ?string

  get type() {
    return 'element'
  }

  constructor(options: {} = {}) {
    this.options = options
  }

  get update() {
    return () => {}
  }

  get plugins() {
    return []
  }

  inputRules(node: Node) {
    return []
  }

  pasteRules(node: Node) {
    return []
  }

  keys(node: Node) {
    return {}
  }
}
