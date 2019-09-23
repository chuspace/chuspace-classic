// @flow

import { InputRule, inputRules } from 'prosemirror-inputrules'
import { Plugin, TextSelection } from 'prosemirror-state'
import { pasteRule, removeMark, updateMark } from 'editor/commands'

import { Mark } from 'editor/base'
import { Mark as PMMark } from 'prosemirror-model'
import { getMarkRange } from 'editor/helpers'
import isUrl from 'is-url'

const LINK_INPUT_REGEX = /(^|[^!])\[(.*?)\]\((\S+)\)(\s)$/
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
      toDOM: (mark: PMMark) => {
        const linkAttrs = isUrl(mark.attrs.href)
          ? {
              rel: 'noopener noreferrer nofollow',
              target: '_blank'
            }
          : {}

        return [
          'a',
          {
            ...mark.attrs,
            ...linkAttrs
          },
          0
        ]
      }
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

  inputRules({ type }: PMMark) {
    const markdownInputRule = new InputRule(LINK_INPUT_REGEX, (state, match, start, end) => {
      const { schema } = state
      const [, prefix, linkText, linkUrl] = match
      const markType = schema.mark('link', { href: linkUrl })

      return state.tr.replaceWith(start + prefix.length, end, schema.text(linkText, [markType]))
    })

    return [markdownInputRule]
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
          handleClick: (view, pos) => {
            const { schema, doc, tr } = view.state
            const range = getMarkRange(doc.resolve(pos), schema.marks.link)

            if (!range) {
              return
            }

            const $start = doc.resolve(range.from)
            const $end = doc.resolve(range.to)

            let parent = $start.parent
            let child = parent.childAfter($start.parentOffset)
            if (!child.node) return

            let link = child.node.marks.find(mark => mark.type.name == this.name)
            const markdownString = `[${child.node.text}](${link.attrs.href})`
            const newTr = tr.insertText(markdownString, range.from, range.to)

            view.dispatch(newTr)
          }
        }
      })
    ]
  }
}
