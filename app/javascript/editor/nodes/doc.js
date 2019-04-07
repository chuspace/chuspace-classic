// @flow

import { Node } from 'editor/utils'

export default class Doc extends Node {
  name = 'doc'

  get schema () {
    return {
      content: 'block+'
    }
  }
}
