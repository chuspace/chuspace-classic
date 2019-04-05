// @flow

import { chainCommands, exitCode } from 'prosemirror-commands'

import { Node } from 'editor/utils'
import type { NodeType } from 'editor/utils'

export default class HardBreak extends Node {
  get name () {
    return 'hard_break'
  }

  get schema () {
    return {
      inline: true,
      group: 'inline',
      selectable: false,
      parseDOM: [{ tag: 'br' }],
      toDOM: () => ['br']
    }
  }

  keys ({ type }: NodeType) {
    const command = chainCommands(exitCode, (state, dispatch) => {
      dispatch(state.tr.replaceSelectionWith(type.create()).scrollIntoView())
      return true
    })
    return {
      'Mod-Enter': command,
      'Shift-Enter': command
    }
  }
}
