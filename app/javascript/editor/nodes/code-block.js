// @flow

import { Fragment, NodeSpec, Node as PMNode, Schema } from 'prosemirror-model'

import { Node } from 'editor/utils'
import type { NodeType } from 'editor/utils'
import { setBlockType } from 'prosemirror-commands'
import { toggleBlockType } from 'editor/commands'

const removeLastNewLine = (dom: HTMLElement): HTMLElement => {
  const parent = dom && dom.parentElement
  if (parent && parent.classList.contains('codehilite')) {
    dom.textContent = dom.textContent.replace(/\n$/, '')
  }
  return dom
}
export default class CodeBlock extends Node {
  name = 'code_block'

  get schema(): NodeSpec {
    return {
      content: 'text*',
      attrs: { language: { default: 'javascript' } },
      marks: '',
      group: 'block',
      code: true,
      defining: true,
      draggable: false,
      parseDOM: [
        {
          tag: 'pre',
          preserveWhitespace: 'full',
          getAttrs: (domNode: PMNode) => {
            let dom = domNode
            const language = dom.getAttribute('data-language')
            dom = removeLastNewLine(dom)
            return { language }
          }
        },
        // Handle VSCode paste
        // Checking `white-space: pre-wrap` is too aggressive @see ED-2627
        {
          tag: 'div[style]',
          preserveWhitespace: 'full',
          getAttrs: (dom: PMNode) => {
            console.log(dom.style)
            if (dom.style.whiteSpace === 'pre') {
              return {}
            }
            return false
          },
          // @see ED-5682
          getContent: (domNode: PMNode, schema: Schema) => {
            const dom = domNode
            const code = Array.from(dom.children)
              .map(child => child.textContent)
              .filter(x => x !== undefined)
              .join('\n')
            return code ? Fragment.from(schema.text(code)) : Fragment.empty
          }
        },
        // Handle GitHub/Gist paste
        {
          tag: 'table[style]',
          preserveWhitespace: 'full',
          getAttrs: (dom: PMNode) => {
            console.log(dom)
            if (dom.querySelector('td[class*="blob-code"]')) {
              return {}
            }
            return false
          }
        },
        {
          tag: 'div.code-block',
          preserveWhitespace: 'full',
          getAttrs: (dom: PMNode) => {
            // TODO: ED-5604 Fix it inside `react-syntax-highlighter`
            // Remove line numbers
            const linesCode = dom.querySelector('code')
            if (linesCode && linesCode.querySelector('.react-syntax-highlighter-line-number')) {
              // It's possible to copy without the line numbers too hence this
              // `react-syntax-highlighter-line-number` check, so that we don't remove real code
              linesCode.remove()
            }
            return {}
          }
        }
      ],
      toDOM(node: PMNode) {
        return ['pre', ['code', { 'data-language': node.attrs.language }, 0]]
      }
    }
  }

  commands({ type, schema }: NodeType) {
    return () => toggleBlockType(type, schema.nodes.paragraph)
  }

  keys({ type }: NodeType) {
    return {
      'Shift-Ctrl-\\': setBlockType(type)
    }
  }
}
