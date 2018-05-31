// @flow

import type { Parent, Node as SlateNode } from 'slate-react'

import { Document } from 'slate'
import type { Node } from 'react'
import React from 'react'

type Props = {
  children: Node,
  node: SlateNode,
  parent: Parent,
  readOnly: boolean
}

const getPlaceholder = type => {
  switch (type) {
    case 'header_one':
      return 'Title'
    case 'paragraph':
      return 'Write your post...'
    default:
      return null
  }
}

export default (props: Props) => {
  const { node, parent, readOnly } = props
  if (node.object !== 'block') return
  if (node.text !== '') return

  const parentIsDocument = parent instanceof Document
  const firstHeading =
    node.type === 'header_one' &&
    parentIsDocument &&
    parent.nodes.first() === node
  const showTitlePlaceholder = firstHeading && !node.text

  console.log(parent.nodes.size)
  const firstParagraph = parent && parent.nodes.get(1) === node
  const lastParagraph = parent && parent.nodes.last() === node
  const showBodyPlaceholder =
    parent.nodes.size <= 2 &&
    !readOnly &&
    parentIsDocument &&
    firstParagraph &&
    lastParagraph &&
    !node.text

  if (!(showBodyPlaceholder || showTitlePlaceholder)) return null

  console.log(!(showBodyPlaceholder || showTitlePlaceholder))
  const placeholder = getPlaceholder(node.type)

  return (
    <span
      style={{
        opacity: '0.3',
        position: 'absolute',
        pointerEvents: 'none',
        userSelect: 'none'
      }}
    >
      {placeholder}
    </span>
  )
}
