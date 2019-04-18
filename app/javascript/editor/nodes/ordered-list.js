// @flow

import { Node } from 'editor/utils'
import type { NodeType } from 'editor/utils'
import { Node as ProsemirrorNode } from 'prosemirror-model'
import { toggleList } from 'editor/commands'
import { wrappingInputRule } from 'prosemirror-inputrules'

export default class OrderedList extends Node {
  name = 'ordered_list'

  get schema() {
    return {
      attrs: {
        order: {
          default: 1
        }
      },
      content: 'list_item+',
      group: 'block',
      parseDOM: [
        {
          tag: 'ol',
          getAttrs: (dom: ProsemirrorNode) => ({
            order: dom.hasAttribute('start') ? +dom.getAttribute('start') : 1
          })
        }
      ],
      toDOM: (node: ProsemirrorNode) =>
        node.attrs.order === 1
          ? ['ol', 0]
          : ['ol', { start: node.attrs.order }, 0]
    }
  }

  commands({ type, schema }: NodeType) {
    return () => toggleList(type, schema.nodes.list_item)
  }

  keys({ type, schema }: NodeType) {
    return {
      'Shift-Ctrl-9': toggleList(type, schema.nodes.list_item)
    }
  }

  inputRules({ type }: NodeType) {
    return [
      wrappingInputRule(
        /^(\d+)\.\s$/,
        type,
        match => ({ order: +match[1] }),
        (match, node) => node.childCount + node.attrs.order === +match[1]
      )
    ]
  }
}
