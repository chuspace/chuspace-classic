// @flow

import type { Node } from 'react'
import React from 'react'

type Props = {
  children: Node
}

export default (props: Props) => (
  <span
    {...props}
    style={{
      position: 'absolute',
      pointerEvents: 'none',
      userSelect: 'none'
    }}
  >
    {props.children}
  </span>
)
