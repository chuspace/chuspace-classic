// @flow

import { markInputRule, markPasteRule, toggleMark } from 'editor/commands'

import { Mark } from 'editor/utils'
import type { MarkType } from 'editor/utils'

export default class Strike extends Mark {
  get name () {
    return 'strike_through'
  }

  get schema () {
    return {
      parseDOM: [
        {
          tag: 's'
        },
        {
          tag: 'del'
        },
        {
          tag: 'strike'
        },
        {
          style: 'text-decoration',
          getAttrs: (value: string) => value === 'line-through'
        }
      ],
      toDOM: () => ['s', 0]
    }
  }

  keys ({ type }: MarkType) {
    return {
      'Mod-d': toggleMark(type)
    }
  }

  commands ({ type }: MarkType) {
    return () => toggleMark(type)
  }

  inputRules ({ type }: MarkType) {
    return [markInputRule(/~([^~]+)~$/, type)]
  }

  pasteRules ({ type }: MarkType) {
    return [markPasteRule(/~([^~]+)~/g, type)]
  }
}
