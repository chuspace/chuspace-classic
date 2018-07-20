// @flow

import { MarkType, NodeType, Schema } from 'prosemirror-model'

import marks from './marks'
import nodes from './nodes'

export const baseSchema: Schema = new Schema({
  nodes: nodes,
  marks: marks,
  topNode: 'doc'
})

const schemaNodes = baseSchema.spec.nodes

export default (addonNodes: NodeType, addonMarks: MarkType): Schema => {
  return new Schema({
    nodes: schemaNodes.append(addonNodes),
    marks: { ...marks, ...addonMarks },
    topNode: 'doc'
  })
}
