// @flow

import { IMAGE } from 'editor/constants/inlines'
import imageNode from 'editor/renderers/ImageNode'
import nodeAttrs from 'editor/attributes/node'
import type { nodeProps } from 'editor/types'

const ImagePlugin = () => {
  const options = Object.assign({
    type: IMAGE,
    getSrc: node => node.data.get('src'),
    getWidth: node => node.data.get('width'),
    getHeight: node => node.data.get('height'),
    ...nodeAttrs
  })

  return {
    renderNode: (props: nodeProps) => {
      if (props.node.type === options.type) return imageNode(options)(props)
    }
  }
}

export default ImagePlugin
