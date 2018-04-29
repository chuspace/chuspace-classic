// @flow

import { HTML } from 'editor/constants/inlines'
import embedNode from 'editor/renderers/embedNode'

const EmbedPlugin = () => {
  const options = Object.assign({
    type: HTML,
    getHref: node => node.data.get('href')
  })

  return {
    renderNode: (props) => {
      if (props.node.type === options.type) return embedNode(options)(props)
    }
  }
}

export default EmbedPlugin
