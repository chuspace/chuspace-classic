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
    tags: {
      nodes: [{ types: ['tag'], min: 0, max: 5 }],
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
        console.log(reason, index)
        switch (reason) {
          case 'child_object_invalid':
            change.wrapBlockByKey(child.key, 'tag')
            return
          case 'child_type_invalid':
            const block = Block.create('tag')
            change.insertNodeByKey(node.key, index, block)
        }
      }
    },
    tag: {
      parent: { types: 'tags' },
      nodes: [{ objects: ['text'] }]
    },
    table: {
      nodes: [{ types: ['table_row', 'table_head', 'table_cell'] }]
    },
    hr: {
      isVoid: true
    }
  },
  document: {
    nodes: [
      {
        types: ['header_one'],
        min: 1,
        max: 1
      },
      {
        types: [
          'paragraph',
          'header_two',
          'header_three',
          'blockquote',
          'code_block',
          'code_line',
          'hr',
          'image',
          'unordered_list',
          'ordered_list',
          'table'
        ],
        min: 1
      },
      {
        types: ['tags'],
        min: 1,
        max: 1
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
      console.log(reason, index)
      switch (reason) {
        case 'child_type_invalid': {
          let type
          switch (index) {
            case 0:
              type = 'header_one'
              break
            case 1:
              type = 'paragraph'
              break
            case 2:
              type = 'tags'
              break
            default:
              break
          }

          console.log(type)
          return change.setNodeByKey(child.key, type)
        }
        case 'child_required': {
          let type
          switch (index) {
            case 0:
              type = 'header_one'
              break
            case 1:
              type = 'paragraph'
              break
            case 2:
              type = 'tags'
              break
            default:
              break
          }

          console.log(type)
          const block = Block.create(type)
          return change.insertNodeByKey(node.key, index, block)
        }
        default:
      }
    }
  }
}

export default schema
