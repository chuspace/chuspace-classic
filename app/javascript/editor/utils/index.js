// @flow

import { Mark, Node, Schema } from 'prosemirror-model'

export type MarkType = { type: Mark }
export type NodeType = { type: Node, schema: Schema }

export { default as ElementManager } from './element-manager'
export { default as Element } from './element'
export { default as Mark } from './mark'
export { default as Node } from './node'
