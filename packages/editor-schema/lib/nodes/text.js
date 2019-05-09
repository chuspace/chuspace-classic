// @flow

import { Node } from '@chuspace/editor-base'

export default class Text extends Node {
  name = 'text'

  get schema() {
    return {
      group: 'inline'
    }
  }
}
