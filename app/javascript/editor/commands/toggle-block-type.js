// @flow

import { EditorState, Transaction } from 'prosemirror-state'

import { EditorView } from 'prosemirror-view'
import { nodeIsActive } from 'editor/helpers'
import { setBlockType } from 'prosemirror-commands'

export default function (type: string, toggletype: string, attrs: {} = {}) {
  return (state: EditorState, dispatch: Transaction, view: EditorView) => {
    const isActive = nodeIsActive(state, type, attrs)

    if (isActive) {
      return setBlockType(toggletype)(state, dispatch, view)
    }

    return setBlockType(type, attrs)(state, dispatch, view)
  }
}
