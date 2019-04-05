// @flow

import { Schema } from 'prosemirror-model'
import marks from 'editor/marks'
import nodes from 'editor/nodes'

export default new Schema({
  nodes: nodes,
  marks: marks
})
