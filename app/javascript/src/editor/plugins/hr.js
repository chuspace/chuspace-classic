// @flow

import { HR } from 'editor/constants/blocks'
import React from 'react'

const HrPlugin = () => {
  const options = Object.assign({
    hrType: HR
  })

  return {
    renderNode: props => {
      if (props.node.type === options.hrType) return <hr />
    }
  }
}

export default HrPlugin
