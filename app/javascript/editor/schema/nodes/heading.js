// @flow

import { setBlockType, toggleBlockType } from 'editor/commands'

import { Node } from 'editor/base'
import { Node as PMNode } from 'prosemirror-model'
import { textblockTypeInputRule } from 'prosemirror-inputrules'

type Options = {
  levels: Array<number>
}

export default class Heading extends Node {
  name = 'heading'

  options: Options = {
    levels: [1, 2, 3, 4, 5, 6]
  }

  get schema() {
    return {
      attrs: {
        level: {
          default: 1
        }
      },
      content: 'inline*',
      group: 'block',
      defining: true,
      draggable: false,
      parseDOM: this.options.levels.map((level: number) => ({
        tag: `h${level}`,
        attrs: { level }
      })),
      toDOM: (node: PMNode) => [`h${node.attrs.level}`, 0]
    }
  }

  commands({ type, schema }: PMNode) {
    return (attrs: {}) => toggleBlockType(type, schema.nodes.paragraph, attrs)
  }

  keys({ type }: PMNode) {
    return this.options.levels.reduce(
      (items, level) => ({
        ...items,
        ...{
          [`Shift-Ctrl-${level}`]: setBlockType(type, { level })
        }
      }),
      {}
    )
  }

  inputRules({ type }: PMNode) {
    return this.options.levels.map(level =>
      textblockTypeInputRule(new RegExp(`^(#{1,${level}})\\s$`), type, () => ({
        level
      }))
    )
  }
}
