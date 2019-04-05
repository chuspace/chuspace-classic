// @flow

import Node from 'editor/utils'

export default class Doc extends Node {
  get name (): string {
    return 'doc'
  }

  get schema () {
    return {
      content: 'block+'
    }
  }
}
