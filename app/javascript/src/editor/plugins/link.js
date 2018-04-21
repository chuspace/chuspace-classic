// @flow

import { LINK } from 'editor/constants/inlines'
import linkNode from 'editor/renderers/linkNode'

const LinkPlugin = opt => {
  const options = Object.assign(
    {
      type: LINK,
      getHref: node => node.data.get('href')
    },
    opt
  )

  return {
    renderNode: props => {
      if (props.node.type === options.type) return linkNode(options)(props)
    }
  }
}

export default LinkPlugin
