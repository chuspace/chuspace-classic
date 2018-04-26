// @flow

import { LINK } from 'editor/constants/inlines'
import linkNode from 'editor/renderers/linkNode'

const LinkPlugin = () => {
  const options = Object.assign({
    type: LINK,
    getHref: node => node.data.get('href')
  })

  return {
    renderNode: props => {
      if (props.node.type === options.type) return linkNode(options)(props)
    }
  }
}

export default LinkPlugin
