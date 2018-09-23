// @flow

import {
  MarkdownSerializerState,
  MarkdownSerializer as PMMarkdownSerializer
} from 'prosemirror-markdown'
import { escapeMarkdown, stringRepeat } from './util'

import { Node as PMNode } from 'prosemirror-model'
import tableNodes from './tableSerializer'

/**
 * Look for series of backticks in a string, find length of the longest one, then
 * generate a backtick chain of a length longer by one. This is the only proven way
 * to escape backticks inside code block and inline code (for python-markdown)
 */
const generateOuterBacktickChain: (
  text: string,
  minLength?: number
) => string = (() => {
  function getMaxLength (text: string): number {
    return (text.match(/`+/g) || []).reduce(
      (prev, val) => (val.length > prev.length ? val : prev),
      ''
    ).length
  }

  return function (text: string, minLength = 1): string {
    const length = Math.max(minLength, getMaxLength(text) + 1)
    return stringRepeat('`', length)
  }
})()

export class MarkdownSerializer extends PMMarkdownSerializer {
  serialize (content: PMNode, options?: { [key: string]: any }): string {
    const state = new MarkdownSerializerState(
      this.nodes,
      this.marks,
      options || {}
    )

    state.renderContent(content)
    return state.out === '\u200c' ? '' : state.out // Return empty string if editor only contains a zero-non-width character
  }
}

const editorNodes = {
  blockquote (
    state: MarkdownSerializerState,
    node: PMNode,
    parent: PMNode,
    index: number
  ) {
    state.wrapBlock('> ', undefined, node, () => state.renderContent(node))
  },
  codeBlock (
    state: MarkdownSerializerState,
    node: PMNode,
    parent: PMNode,
    index: number
  ) {
    if (!node.attrs.language) {
      state.wrapBlock('    ', undefined, node, () =>
        state.text(node.textContent ? node.textContent : '\u200c', false)
      )
    } else {
      const backticks = generateOuterBacktickChain(node.textContent, 3)
      state.write(backticks + node.attrs.language + '\n')
      state.text(node.textContent ? node.textContent : '\u200c', false)
      state.ensureNewLine()
      state.write(backticks)
    }
    state.closeBlock(node)
  },
  heading (
    state: MarkdownSerializerState,
    node: PMNode,
    parent: PMNode,
    index: number
  ) {
    state.write(state.repeat('#', node.attrs.level) + ' ')
    state.renderInline(node)
    state.closeBlock(node)
  },
  title (
    state: MarkdownSerializerState,
    node: PMNode,
    parent: PMNode,
    index: number
  ) {
    state.write(state.repeat('#', 1) + ' ')
    state.renderInline(node)
    state.closeBlock(node)
  },
  subtitle (
    state: MarkdownSerializerState,
    node: PMNode,
    parent: PMNode,
    index: number
  ) {
    state.write(state.repeat('#', 2) + ' ')
    state.renderInline(node)
    state.closeBlock(node)
  },
  rule (state: MarkdownSerializerState, node: PMNode) {
    state.write(node.attrs.markup || '---')
    state.closeBlock(node)
  },
  bulletList (
    state: MarkdownSerializerState,
    node: PMNode,
    parent: PMNode,
    index: number
  ) {
    for (let i = 0; i < node.childCount; i++) {
      const child = node.child(i)
      state.render(child, node, i)
    }
  },
  orderedList (
    state: MarkdownSerializerState,
    node: PMNode,
    parent: PMNode,
    index: number
  ) {
    for (let i = 0; i < node.childCount; i++) {
      const child = node.child(i)
      state.render(child, node, i)
    }
  },
  listItem (
    state: MarkdownSerializerState,
    node: PMNode,
    parent: PMNode,
    index: number
  ) {
    const delimiter =
      parent.type.name === 'bulletList' ? '* ' : `${index + 1}. `
    for (let i = 0; i < node.childCount; i++) {
      const child = node.child(i)
      if (i > 0) {
        state.write('\n')
      }
      if (i === 0) {
        state.wrapBlock('  ', delimiter, node, () =>
          state.render(child, parent, i)
        )
      } else {
        state.wrapBlock('    ', undefined, node, () =>
          state.render(child, parent, i)
        )
      }
      if (child.type.name === 'paragraph' && i > 0) {
        state.write('\n')
      }
      state.flushClose(1)
    }
    if (index === parent.childCount - 1) {
      state.write('\n')
    }
  },
  paragraph (
    state: MarkdownSerializerState,
    node: PMNode,
    parent: PMNode,
    index: number
  ) {
    state.renderInline(node)
    state.closeBlock(node)
  },
  mediaGroup (state: MarkdownSerializerState, node: PMNode) {
    for (let i = 0; i < node.childCount; i++) {
      const child = node.child(i)
      state.render(child, node, i)
    }
  },
  mediaSingle (state: MarkdownSerializerState, node: PMNode, parent: PMNode) {
    for (let i = 0; i < node.childCount; i++) {
      const child = node.child(i)
      state.render(child, node, i)
      if (!parent.type.name.startsWith('table')) {
        state.write('\n')
      }
    }
  },
  media (state: MarkdownSerializerState, node: PMNode) {
    state.write('![](' + node.attrs.url + ')')
  },
  image (state: MarkdownSerializerState, node: PMNode) {
    // Note: the 'title' is not escaped in this flavor of markdown.
    state.write(
      '![' +
        escapeMarkdown(node.attrs.alt) +
        '](' +
        node.attrs.src +
        (node.attrs.title ? ` '${escapeMarkdown(node.attrs.title)}'` : '') +
        ')'
    )
  },
  hardBreak (state: MarkdownSerializerState) {
    state.write('  \n')
  },
  text (
    state: MarkdownSerializerState,
    node: PMNode,
    parent: PMNode,
    index: number
  ) {
    const previousNode = index === 0 ? null : parent.child(index - 1)
    const previousNodeIsAMention =
      previousNode && previousNode.type.name === 'mention'
    const currentNodeStartWithASpace = node.textContent.indexOf(' ') === 0
    const trimTrailingWhitespace =
      previousNodeIsAMention && currentNodeStartWithASpace
    let text = trimTrailingWhitespace
      ? node.textContent.replace(' ', '') // only first blank space occurrence is replaced
      : node.textContent

    // BB converts 4 spaces at the beginning of the line to code block
    // that's why we escape 4 spaces with zero-width-non-joiner
    const fourSpaces = '    '
    if (!previousNode && /^\s{4}/.test(node.textContent)) {
      text = node.textContent.replace(fourSpaces, '\u200c' + fourSpaces)
    }

    const lines = text.split('\n')
    for (let i = 0; i < lines.length; i++) {
      const startOfLine = state.atBlank() || !!state.closed
      state.write()
      state.out += escapeMarkdown(lines[i], startOfLine)
      if (i !== lines.length - 1) {
        if (
          lines[i] &&
          lines[i].length &&
          lines[i + 1] &&
          lines[i + 1].length
        ) {
          state.out += '  '
        }
        state.out += '\n'
      }
    }
  },
  empty_line (state: MarkdownSerializerState, node: PMNode) {
    state.write('\u200c') // zero-width-non-joiner
    state.closeBlock(node)
  },
  mention (
    state: MarkdownSerializerState,
    node: PMNode,
    parent: PMNode,
    index: number
  ) {
    const isLastNode = parent.childCount === index + 1
    const delimiter = isLastNode ? '' : ' '

    state.write(`@${node.attrs.id}${delimiter}`)
  },

  tags (
    state: MarkdownSerializerState,
    node: PMNode,
    parent: PMNode,
    index: number
  ) {
    state.write('tags')
  },
  emoji (
    state: MarkdownSerializerState,
    node: PMNode,
    parent: PMNode,
    index: number
  ) {
    state.write(node.attrs.shortName)
  }
}

export const nodes = { ...editorNodes, ...tableNodes }

export const marks = {
  em: { open: '*', close: '*', mixable: true },
  strong: { open: '**', close: '**', mixable: true },
  strike: { open: '~~', close: '~~', mixable: true },
  link: {
    open: '[',
    close (state: MarkdownSerializerState, mark: any) {
      return '](' + mark.attrs['href'] + ')'
    }
  },
  code: { open: '`', close: '`' },
  mentionQuery: { open: '', close: '', mixable: false },
  emojiQuery: { open: '', close: '', mixable: false }
}

export default new MarkdownSerializer(nodes, marks)
