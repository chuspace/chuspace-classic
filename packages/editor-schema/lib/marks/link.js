// @flow

import { Plugin, TextSelection } from 'prosemirror-state'
import { pasteRule, removeMark, updateMark } from '@chuspace/editor-commands'

import { Mark } from '@chuspace/editor-base'
import { Mark as PMMark } from 'prosemirror-model'
import { getMarkRange } from '@chuspace/editor-helpers'

export default class Link extends Mark {
  name = 'link'

  get schema() {
    return {
      attrs: {
        href: {
          default: null
        }
      },
      inclusive: false,
      parseDOM: [
        {
          tag: 'a[href]',
          getAttrs: (dom: PMMark) => ({
            href: dom.getAttribute('href')
          })
        }
      ],
      toDOM: (mark: PMMark) => [
        'a',
        {
          ...mark.attrs,
          rel: 'noopener noreferrer nofollow'
        },
        0
      ]
    }
  }

  commands({ type }: PMMark) {
    return (attrs: any) => {
      if (attrs.href) {
        return updateMark(type, attrs)
      }

      return removeMark(type)
    }
  }

  pasteRules({ type }: PMMark) {
    return [
      pasteRule(
        /https?:\/\/(www\.)?[-a-zA-Z0-9@:%._+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_+.~#?&//=]*)/g,
        type,
        url => ({ href: url })
      )
    ]
  }

  get plugins() {
    return [
      new Plugin({
        props: {
          handleClick(view, pos) {
            const { schema, doc, tr } = view.state
            const range = getMarkRange(doc.resolve(pos), schema.marks.link)

            if (!range) {
              return
            }

            const $start = doc.resolve(range.from)
            const $end = doc.resolve(range.to)
            const transaction = tr.setSelection(new TextSelection($start, $end))

            view.dispatch(transaction)
          }
        }
      })
    ]
  }
}
