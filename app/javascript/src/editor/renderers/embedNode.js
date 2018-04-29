// @flow
import * as React from 'react'

import Video from './videoNode'

export default function (options) {
  const EmbedNode = (props: nodeProps) => {
    return <Video {...props} options={options} />
  }

  EmbedNode.displayName = `embed-node`

  return EmbedNode
}
