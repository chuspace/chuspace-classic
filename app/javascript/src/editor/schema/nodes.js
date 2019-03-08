import { bulletList, listItem, orderedList } from 'prosemirror-schema-list'

import { nodes } from 'prosemirror-schema-basic'
import { tableNodes } from 'prosemirror-tables'

const listNodes = {
  ordered_list: {
    ...orderedList,
    content: 'list_item+',
    group: 'block'
  },
  bullet_list: {
    ...bulletList,
    content: 'list_item+',
    group: 'block'
  },
  list_item: {
    ...listItem,
    content: 'paragraph block*',
    group: 'block'
  }
}

export default {
  ...nodes,
  title: {
    attrs: { class: { default: 'title' } },
    content: 'inline*',
    group: 'block',
    defining: true,
    parseDOM: [
      {
        tag: 'h1',
        getAttrs: node => {
          return {
            class: node.getAttribute('class')
          }
        }
      }
    ],
    toDOM (node) {
      return ['h1', node.attrs, 0]
    }
  },

  subtitle: {
    attrs: { class: { default: 'subtitle' } },
    content: 'inline*',
    group: 'block',
    defining: true,
    parseDOM: [
      {
        tag: 'h2',
        getAttrs: node => {
          return {
            class: node.getAttribute('class')
          }
        }
      }
    ],
    toDOM (node) {
      return ['h2', node.attrs, 0]
    }
  },

  tags: {
    attrs: { class: { default: 'tags' } },
    content: 'inline*',
    group: 'block',
    defining: true,
    parseDOM: [
      {
        tag: 'div',
        getAttrs: node => {
          return {
            class: node.getAttribute('class')
          }
        }
      }
    ],
    toDOM (node) {
      return ['div', node.attrs, 0]
    }
  },
  doc: {
    content: 'title subtitle? block+ tags'
  },
  ...listNodes,
  ...tableNodes({
    tableGroup: 'block',
    cellContent: 'block+'
  })
}
