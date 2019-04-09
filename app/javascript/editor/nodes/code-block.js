// @flow

import { Node } from 'editor/utils'
import type { NodeType } from 'editor/utils'
import { setBlockType } from 'prosemirror-commands'
import { toggleBlockType } from 'editor/commands'

export default class CodeBlock extends Node {
  name = 'code_block'

  get schema () {
    return {
      content: 'text*',
      attrs: { language: { default: 'javascript' } },
      marks: '',
      group: 'block',
      code: true,
      defining: true,
      draggable: false,
      parseDOM: [{ tag: 'pre', preserveWhitespace: 'full' }],
      toDOM: () => ['pre', ['code', 0]]
    }
  }

  commands ({ type, schema }: NodeType) {
    return () => toggleBlockType(type, schema.nodes.paragraph)
  }

  keys ({ type }: NodeType) {
    return {
      'Shift-Ctrl-\\': setBlockType(type)
    }
  }
}
