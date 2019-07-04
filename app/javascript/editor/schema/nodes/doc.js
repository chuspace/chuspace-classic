// @flow

import { Node } from 'editor/base'

export default class Doc extends Node {
  name = 'doc'

  get schema() {
    return {
      content: 'heading block+'
    }
  }
}
