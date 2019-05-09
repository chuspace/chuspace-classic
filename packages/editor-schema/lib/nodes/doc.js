// @flow

import { Node } from '@chuspace/editor-base'

export default class Doc extends Node {
  name = 'doc'

  get schema() {
    return {
      content: 'block+'
    }
  }
}
