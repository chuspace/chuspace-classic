// @flow

import { Node } from 'editor/utils'
import type { NodeType } from 'editor/utils'
import { toggleWrap } from 'editor/commands'
import { wrappingInputRule } from 'prosemirror-inputrules'

export default class Blockquote extends Node {
  get name (): string {
    return 'blockquote'
  }

  get schema () {
    return {
      content: 'block*',
      group: 'block',
      defining: true,
      draggable: false,
      parseDOM: [{ tag: 'blockquote' }],
      toDOM: () => ['blockquote', 0]
    }
  }

  commands ({ type, schema }: NodeType) {
    return () => toggleWrap(type, schema.nodes.paragraph)
  }

  keys ({ type }: NodeType) {
    return {
      'Ctrl->': toggleWrap(type)
    }
  }

  inputRules ({ type }: NodeType) {
    return [wrappingInputRule(/^\s*>\s$/, type)]
  }
}
