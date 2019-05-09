// @flow

import { markInputRule, markPasteRule } from '@chuspace/editor-commands'

import { Mark } from '@chuspace/editor-base'
import { Mark as PMMark } from 'prosemirror-model'
import { toggleMark } from 'prosemirror-commands'

export default class Code extends Mark {
  name = 'code'

  get schema() {
    return {
      parseDOM: [{ tag: 'code' }],
      toDOM: () => ['code', 0]
    }
  }

  keys({ type }: PMMark) {
    return {
      'Mod-`': toggleMark(type)
    }
  }

  commands({ type }: PMMark) {
    return () => toggleMark(type)
  }

  inputRules({ type }: PMMark) {
    return [markInputRule(/(?:`)([^`]+)(?:`)$/, type)]
  }

  pasteRules({ type }: PMMark) {
    return [markPasteRule(/(?:`)([^`]+)(?:`)/g, type)]
  }
}
