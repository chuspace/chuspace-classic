// @flow

import * as React from 'react'

import { Document } from 'slate'
import Placeholder from './placeholderNode'
import mapValues from 'lodash/mapValues'
import type { nodeProps } from 'types/editor'

export default function (Tag, stylesAttr) {
  const NodeComponent = ({
    attributes,
    children,
    node,
    parent,
    editor
  }: nodeProps) => {
    const placeholder = Tag === 'h1'
    const parentIsDocument = parent instanceof Document
    const firstHeading = parentIsDocument && parent.nodes.first() === node
    const showPlaceholder = placeholder && firstHeading && !node.text

    console.log(!node.text)
    return (
      <Tag
        {...attributes}
        data-slate-type={Tag}
        style={mapValues(stylesAttr, val => val && val(node))}
      >
        {showPlaceholder && (
          <Placeholder contentEditable={false}>
            {editor.props.titlePlaceholder}
          </Placeholder>
        )}
        {children}
      </Tag>
    )
  }

  NodeComponent.displayName = `${Tag}-node`

  return NodeComponent
}
