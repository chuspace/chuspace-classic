/* eslint-disable react/prop-types */
import React from 'react'

const marks = {
  em: {
    parseDOM: [
      { tag: 'i' },
      { tag: 'em' },
      {
        style: 'font-style',
        getAttrs: value => value === 'italic' && null
      }
    ],
    toDOM () {
      return ['em']
    },
    toStatic (mark, children) {
      return <em>{children}</em>
    }
  },

  strong: {
    parseDOM: [
      { tag: 'strong' },
      // This works around a Google Docs misbehavior where
      // pasted content will be inexplicably wrapped in `<b>`
      // tags with a font-weight normal.
      {
        tag: 'b',
        getAttrs: node => node.style.fontWeight !== 'normal' && null
      },
      {
        style: 'font-weight',
        getAttrs: value => /^(bold(er)?|[5-9]\d{2,})$/.test(value) && null
      }
    ],
    toDOM () {
      return ['strong']
    },
    toStatic (mark, children) {
      return <strong>{children}</strong>
    }
  },
  link: {
    attrs: {
      href: { default: '' },
      title: { default: null },
      target: { default: null }
    },
    parseDOM: [
      {
        tag: 'a[href]',
        getAttrs (dom) {
          return {
            href: dom.getAttribute('href'),
            title: dom.getAttribute('title'),
            target: dom.getAttribute('target')
          }
        }
      }
    ],
    toDOM (node) {
      return ['a', node.attrs]
    },
    toStatic (mark, children) {
      return (
        <a
          href={mark.attrs.href}
          title={mark.attrs.title}
          target={mark.attrs.target}
        >
          {children}
        </a>
      )
    }
  },
  sub: {
    parseDOM: [{ tag: 'sub' }],
    toDOM () {
      return ['sub']
    },
    toStatic (mark, children) {
      return <sub>{children}</sub>
    }
  },
  sup: {
    parseDOM: [{ tag: 'sup' }],
    toDOM () {
      return ['sup']
    },
    toStatic (mark, children) {
      return <sup>{children}</sup>
    }
  },
  strike: {
    parseDOM: [{ tag: 's' }],
    toDOM () {
      return ['s']
    },
    toStatic (mark, children) {
      return <s>{children}</s>
    }
  },
  code: {
    parseDOM: [{ tag: 'code' }],
    toDOM () {
      return ['code']
    },
    toStatic (mark, children) {
      return <code>{children}</code>
    }
  }
}

export default marks
