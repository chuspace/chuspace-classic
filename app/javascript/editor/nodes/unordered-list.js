// @flow

import { Node } from 'editor/utils'
import type { NodeType } from 'editor/utils'
import { toggleList } from 'editor/commands'
import { wrappingInputRule } from 'prosemirror-commands'

export default class UnorderedList extends Node {
  get name () {
    return 'unordered_list'
  }

  get schema () {
    return {
      content: 'list_item+',
      group: 'block',
      parseDOM: [{ tag: 'ul' }],
      toDOM: () => ['ul', 0]
    }
  }

  commands ({ type, schema }: NodeType) {
    return () => toggleList(type, schema.nodes.list_item)
  }

  keys ({ type, schema }: NodeType) {
    return {
      'Shift-Ctrl-8': toggleList(type, schema.nodes.list_item)
    }
  }

  inputRules ({ type }: NodeType) {
    return [wrappingInputRule(/^\s*([-+*])\s$/, type)]
  }
}
