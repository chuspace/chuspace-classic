// @flow

import { markInputRule, markPasteRule } from 'editor/commands'

import { Mark } from 'editor/utils'
import type { MarkType } from 'editor/utils'
import { Node } from 'prosemirror-model'
import { toggleMark } from 'prosemirror-commands'

export default class Bold extends Mark {
  name = 'bold'

  get schema () {
    return {
      parseDOM: [
        {
          tag: 'strong'
        },
        {
          tag: 'b',
          getAttrs: (node: Node) => node.style.fontWeight !== 'normal' && null
        },
        {
          style: 'font-weight',
          getAttrs: (value: string) =>
            /^(bold(er)?|[5-9]\d{2,})$/.test(value) && null
        }
      ],
      toDOM: () => ['strong', 0]
    }
  }

  keys ({ type }: MarkType) {
    return {
      'Mod-b': toggleMark(type)
    }
  }

  commands ({ type }: MarkType) {
    return () => toggleMark(type)
  }

  inputRules ({ type }: MarkType) {
    return [markInputRule(/(?:\*\*|__)([^*_]+)(?:\*\*|__)$/, type)]
  }

  pasteRules ({ type }: MarkType) {
    return [markPasteRule(/(?:\*\*|__)([^*_]+)(?:\*\*|__)/g, type)]
  }
}
