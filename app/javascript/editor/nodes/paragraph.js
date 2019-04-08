// @flow

import { Node } from 'editor/utils'
import type { NodeType } from 'editor/utils'
import { setBlockType } from 'prosemirror-commands'

export default class Paragraph extends Node {
  name = 'paragraph'

  get schema () {
    return {
      content: 'inline*',
      group: 'block',
      draggable: false,
      parseDOM: [
        {
          tag: 'p'
        }
      ],
      toDOM: () => ['p', 0]
    }
  }

  commands ({ type }: NodeType) {
    return () => setBlockType(type)
  }
}
