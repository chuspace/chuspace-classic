// @flow

import Node from 'editor/utils'

export default class Text extends Node {
  get name (): string {
    return 'text'
  }

  get schema () {
    return {
      group: 'inline'
    }
  }
}
