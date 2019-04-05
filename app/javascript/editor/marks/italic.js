// @flow

import { markInputRule, markPasteRule } from 'editor/commands'

import { Mark } from 'editor/utils'
import type { MarkType } from 'editor/utils'
import { toggleMark } from 'prosemirror-commands'

export default class Italic extends Mark {
  get name (): string {
    return 'italic'
  }

  get schema () {
    return {
      parseDOM: [{ tag: 'i' }, { tag: 'em' }, { style: 'font-style=italic' }],
      toDOM: () => ['em', 0]
    }
  }

  keys ({ type }: MarkType) {
    return {
      'Mod-i': toggleMark(type)
    }
  }

  commands ({ type }: MarkType) {
    return () => toggleMark(type)
  }

  inputRules ({ type }: MarkType) {
    return [markInputRule(/(?:^|[^*_])(?:\*|_)([^*_]+)(?:\*|_)$/, type)]
  }

  pasteRules ({ type }: MarkType) {
    return [markPasteRule(/(?:^|[^*_])(?:\*|_)([^*_]+)(?:\*|_)/g, type)]
  }
}
