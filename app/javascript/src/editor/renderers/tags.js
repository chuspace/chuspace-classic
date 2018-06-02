// @flow
import * as React from 'react'

import type { nodeProps } from 'editor/types'

export default function Tags () {
  const TagsNode = ({ attributes, children, node }: nodeProps) => {
    return (
      <div
        {...attributes}
        data-slate-type='tags'
      >
        {children}
      </div>
    )
  }

  TagsNode.displayName = `tags-node`

  return TagsNode
}
