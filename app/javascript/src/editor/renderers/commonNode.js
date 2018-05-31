import * as React from 'react'

import mapValues from 'lodash/mapValues'
// @flow
import type { nodeProps } from 'types/editor'

export default function (Tag, stylesAttr) {
  const NodeComponent = ({ attributes, children, node }: nodeProps) => {
    return (
      <Tag
        {...attributes}
        data-slate-type={Tag}
        style={mapValues(stylesAttr, val => val && val(node))}
      >
        {children}
      </Tag>
    )
  }

  NodeComponent.displayName = `${Tag}-node`

  return NodeComponent
}
