// @flow

import { Block, Change, Mark, Node } from 'slate'

const schema = {
  blocks: {
    header_one: { nodes: [{ objects: ['text'] }], marks: [''] },
    header_two: { nodes: [{ objects: ['text'] }], marks: [''] },
    header_three: { nodes: [{ objects: ['text'] }], marks: [''] },
    header_four: { nodes: [{ objects: ['text'] }], marks: [''] },
    header_five: { nodes: [{ objects: ['text'] }], marks: [''] },
    header_six: { nodes: [{ objects: ['text'] }], marks: [''] },
    blockquote: { marks: [''] },
    table: {
      nodes: [{ types: ['table_row', 'table_head', 'table_cell'] }]
    },
    'horizontal-rule': {
      isVoid: true
    },
    'block-toolbar': {
      isVoid: true
    }
  },
  document: {
    nodes: [
      { types: ['header_one'], min: 1, max: 1 },
      {
        types: [
          'paragraph',
          'header_one',
          'header_two',
          'header_three',
          'header_four',
          'header_five',
          'header_six',
          'blockquote',
          'code_block',
          'code_line',
          'hr',
          'image',
          'unordered_list',
          'ordered_list',
          'table'
        ],
        min: 0
      }
    ],
    normalize: (
      change: Change,
      reason: string,
      {
        node,
        child,
        mark,
        index
      }: { node: Node, mark?: Mark, child: Node, index: number }
    ) => {
      switch (reason) {
        case 'child_type_invalid': {
          return change.setNodeByKey(
            child.key,
            index === 0 ? 'header_one' : 'paragraph'
          )
        }
        case 'child_required': {
          const block = Block.create(index === 0 ? 'header_one' : 'paragraph')
          return change.insertNodeByKey(node.key, index, block)
        }
        default:
      }
    }
  }
}

export default schema
