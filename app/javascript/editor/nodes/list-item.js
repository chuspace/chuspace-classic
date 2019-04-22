// @flow

import { liftListItem, sinkListItem, splitListItem } from 'prosemirror-schema-list'

import { Node } from 'editor/utils'
import type { NodeType } from 'editor/utils'

export default class ListItem extends Node {
  name = 'list_item'

  get schema() {
    return {
      content: 'paragraph block*',
      defining: true,
      draggable: false,
      parseDOM: [{ tag: 'li' }],
      toDOM: () => ['li', 0]
    }
  }

  keys({ type }: NodeType) {
    return {
      Enter: splitListItem(type),
      Tab: sinkListItem(type),
      'Shift-Tab': liftListItem(type)
    }
  }
}
