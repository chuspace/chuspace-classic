// @flow

import React from 'react'

type Props = {
  text: string
}

const Placeholder = (props: Props) => (
  <span
    contentEditable={false}
    style={{
      opacity: '0.3',
      position: 'absolute',
      pointerEvents: 'none',
      userSelect: 'none'
    }}
  >
    {props.text}
  </span>
)

export default Placeholder
