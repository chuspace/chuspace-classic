// @flow

import { EditorState, Transaction } from 'prosemirror-state'

import { Node } from 'editor/utils'
import type { NodeType } from 'editor/utils'
import { nodeInputRule } from 'editor/commands'

export default class HorizontalRule extends Node {
  get name (): string {
    return 'horizontal_rule'
  }

  get schema () {
    return {
      group: 'block',
      parseDOM: [{ tag: 'hr' }],
      toDOM: () => ['hr']
    }
  }

  commands ({ type }: NodeType) {
    return () => (state: EditorState, dispatch: Transaction) =>
      dispatch(state.tr.replaceSelectionWith(type.create()))
  }

  inputRules ({ type }: NodeType) {
    return [nodeInputRule(/^(?:---|___\s|\*\*\*\s)$/, type)]
  }
}
