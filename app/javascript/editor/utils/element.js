// @flow

import type { NodeType } from './index'

export default class Element {
  options: any
  name: ?string

  get type () {
    return 'element'
  }

  constructor (options: {} = {}) {
    this.options = options
  }

  get update () {
    return () => {}
  }

  get plugins () {
    return []
  }

  inputRules (node: NodeType) {
    return []
  }

  pasteRules (node: NodeType) {
    return []
  }

  keys (node: NodeType) {
    return {}
  }
}
