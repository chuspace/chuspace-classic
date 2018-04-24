// @flow
import type { nodeProps } from 'types/editor'

import * as React from 'react'
import mapValues from 'lodash/mapValues'

export default function (Tag, stylesAttr) {
  const NodeComponent = ({ attributes, children, node }: nodeProps) => {
    console.log(mapValues(stylesAttr, val => val && val(node)))
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
