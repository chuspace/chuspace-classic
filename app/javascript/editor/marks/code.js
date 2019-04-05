// @flow

import { markInputRule, markPasteRule } from 'editor/commands'

import { Mark } from 'editor/utils'
import type { MarkType } from 'editor/utils'
import { toggleMark } from 'prosemirror-commands'

export default class Code extends Mark {
  get name (): string {
    return 'code'
  }

  get schema () {
    return {
      parseDOM: [{ tag: 'code' }],
      toDOM: () => ['code', 0]
    }
  }

  keys ({ type }: MarkType) {
    return {
      'Mod-`': toggleMark(type)
    }
  }

  commands ({ type }: MarkType) {
    return () => toggleMark(type)
  }

  inputRules ({ type }: MarkType) {
    return [markInputRule(/(?:`)([^`]+)(?:`)$/, type)]
  }

  pasteRules ({ type }: MarkType) {
    return [markPasteRule(/(?:`)([^`]+)(?:`)/g, type)]
  }
}
