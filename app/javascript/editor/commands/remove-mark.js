// @flow

import { EditorState, Transaction } from 'prosemirror-state'

export default function (type: string) {
  return (state: EditorState, dispatch: Transaction) => {
    const { from, to } = state.selection
    return dispatch(state.tr.removeMark(from, to, type))
  }
}
