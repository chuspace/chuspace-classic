import EmbedComponent from 'editor/renderers/embedNode'
// @flow
import INLINES from 'markup-it/lib/constants/inlines'
import React from 'react'

console.log(INLINES)
const EmbedPlugin = () => {
  const options = Object.assign({
    type: INLINES.HTML,
    getHref: node => node.data.get('html')
  })

  return {
    renderNode: props => {
      if (props.node.type === options.type) {
        return <EmbedComponent {...props} options={options} />
      }
    }
  }
}

export default EmbedPlugin
