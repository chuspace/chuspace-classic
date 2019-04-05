import { Schema } from 'prosemirror-model'

export type MarkType = { type: string }
export type NodeType = { type: string, schema: Schema }

export { default as ExtensionManager } from './extension-manager'
export { default as Extension } from './extension'
export { default as Mark } from './mark'
export { default as Node } from './node'
