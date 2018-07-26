// @flow

import { NodeType } from 'prosemirror-model'
import React from 'react'

const nodes: NodeType = {
  doc: {
    content: 'block+',
    attrs: {
      meta: { default: {} }
    }
  },
  paragraph: {
    content: 'inline*',
    group: 'block',
    attrs: {
      class: { default: null }
    },
    parseDOM: [
      {
        tag: 'p',
        getAttrs (dom) {
          return {
            class: dom.getAttribute('class')
          }
        }
      }
    ],
    toDOM (node) {
      return ['p', node.attrs, 0]
    },
    toStatic (node, children) {
      const attrs = {}
      if (node.attrs && node.attrs.class) {
        attrs.className = node.attrs.class
      }
      const emptyChildren = <br />
      return (
        <p {...attrs} key={node.currIndex}>
          {children || emptyChildren}
        </p>
      )
    }
  },
  blockquote: {
    content: 'block+',
    group: 'block',
    parseDOM: [{ tag: 'blockquote' }],
    toDOM () {
      return ['blockquote', 0]
    },
    toStatic (node, children) {
      return <blockquote key={node.currIndex}>{children}</blockquote>
    }
  },
  horizontal_rule: {
    group: 'block',
    parseDOM: [{ tag: 'hr' }],
    toDOM () {
      return ['div', ['hr']]
    },
    toStatic (node) {
      return <hr key={node.currIndex} />
    }
  },
  heading: {
    attrs: {
      level: { default: 1 },
      id: { default: '' }
    },
    content: 'inline*',
    group: 'block',
    defining: true,
    parseDOM: [
      {
        tag: 'h1',
        getAttrs (dom) {
          return { level: 1, id: dom.getAttribute('id') }
        }
      },
      {
        tag: 'h2',
        getAttrs (dom) {
          return { level: 2, id: dom.getAttribute('id') }
        }
      },
      {
        tag: 'h3',
        getAttrs (dom) {
          return { level: 3, id: dom.getAttribute('id') }
        }
      },
      {
        tag: 'h4',
        getAttrs (dom) {
          return { level: 4, id: dom.getAttribute('id') }
        }
      },
      {
        tag: 'h5',
        getAttrs (dom) {
          return { level: 5, id: dom.getAttribute('id') }
        }
      },
      {
        tag: 'h6',
        getAttrs (dom) {
          return { level: 6, id: dom.getAttribute('id') }
        }
      }
    ],
    toDOM (node) {
      if (!node.attrs.id) {
        return [`h${node.attrs.level}`, { id: node.attrs.id }, 0]
      }
      return [
        `h${node.attrs.level}`,
        { id: node.attrs.id },
        ['span', 0],
        [
          'a',
          {
            href: `#${node.attrs.id}`,
            contenteditable: 'false',
            class: 'header-link pt-button pt-minimal pt-icon-link'
          }
        ]
      ]
    },
    toStatic (node, children, editorProps) {
      const headerLink =
        node.attrs.id && editorProps.showHeaderLinks ? (
          <a
            href={`#${node.attrs.id}`}
            contentEditable='false'
            className='header-link pt-button pt-minimal pt-icon-link'
          />
        ) : null
      if (node.attrs.level === 1) {
        return (
          <h1 key={node.currIndex} id={node.attrs.id}>
            {children}
            {headerLink}
          </h1>
        )
      }
      if (node.attrs.level === 2) {
        return (
          <h2 key={node.currIndex} id={node.attrs.id}>
            {children}
            {headerLink}
          </h2>
        )
      }
      if (node.attrs.level === 3) {
        return (
          <h3 key={node.currIndex} id={node.attrs.id}>
            {children}
            {headerLink}
          </h3>
        )
      }
      if (node.attrs.level === 4) {
        return (
          <h4 key={node.currIndex} id={node.attrs.id}>
            {children}
            {headerLink}
          </h4>
        )
      }
      if (node.attrs.level === 5) {
        return (
          <h5 key={node.currIndex} id={node.attrs.id}>
            {children}
            {headerLink}
          </h5>
        )
      }
      if (node.attrs.level === 6) {
        return (
          <h6 key={node.currIndex} id={node.attrs.id}>
            {children}
            {headerLink}
          </h6>
        )
      }
      return null
    }
  },
  ordered_list: {
    content: 'list_item+',
    group: 'block',
    attrs: { order: { default: 1 } },
    parseDOM: [
      {
        tag: 'ol',
        getAttrs (dom) {
          return {
            order: dom.hasAttribute('start') ? +dom.getAttribute('start') : 1
          }
        }
      }
    ],
    toDOM (node) {
      return [
        'ol',
        { start: node.attrs.order === 1 ? null : node.attrs.order },
        0
      ]
    },
    toStatic (node, children) {
      const attrs = { start: node.attrs.order === 1 ? null : node.attrs.order }
      return (
        <ol key={node.currIndex} {...attrs}>
          {children}
        </ol>
      )
    }
  },
  bullet_list: {
    content: 'list_item+',
    group: 'block',
    parseDOM: [{ tag: 'ul' }],
    toDOM () {
      return ['ul', 0]
    },
    toStatic (node, children) {
      return <ul key={node.currIndex}>{children}</ul>
    }
  },
  list_item: {
    content: 'paragraph block*',
    parseDOM: [{ tag: 'li' }],
    toDOM () {
      return ['li', 0]
    },
    defining: true,
    toStatic (node, children) {
      return <li key={node.currIndex}>{children}</li>
    }
  },
  code_block: {
    content: 'text*',
    group: 'block',
    code: true,
    parseDOM: [{ tag: 'pre', preserveWhitespace: true }],
    toDOM () {
      return ['pre', ['code', 0]]
    },
    toStatic (node, children) {
      return (
        <pre key={node.currIndex}>
          <code>{children}</code>
        </pre>
      )
    }
  },
  text: {
    group: 'inline',
    toDOM (node) {
      return node.text
    },
    toStatic (node, children, editorProps) {
      return editorProps.renderStaticMarkup ? (
        children
      ) : (
        <span key={node.currIndex}>{children}</span>
      )
    }
  },
  hard_break: {
    inline: true,
    group: 'inline',
    selectable: false,
    parseDOM: [{ tag: 'br' }],
    toDOM () {
      return ['br']
    },
    toStatic (node) {
      return <br key={node.currIndex} />
    }
  },
  none: {
    // empty schema block
    group: 'block',
    toDOM () {
      return ['span']
    },
    toStatic (node, children) {
      return <span key={node.currIndex}>{children}</span>
    }
  }
}

export default nodes
