import React from 'react'
import { HR } from 'editor/constants/blocks'

const HrPlugin = () => {
  const options = Object.assign(
    {
      hrType: HR
    }
  )

  return {
    renderNode: props => {
      if (props.node.type === options.hrType) return <hr />
    }
  }
}

export default HrPlugin
