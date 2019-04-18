// @flow

import { Node } from 'editor/utils'

export default class Text extends Node {
  name = 'text'

  get schema() {
    return {
      group: 'inline'
    }
  }
}
