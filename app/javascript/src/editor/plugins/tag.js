// @flow

import { TAG, TAGS } from 'editor/constants/blocks'

import type { nodeProps } from 'editor/types'
import tagNode from 'editor/renderers/tag'
import tagsNode from 'editor/renderers/tags'

const TagPlugin = () => {
  const options = Object.assign({
    tagsType: TAGS,
    tagType: TAG
  })

  return {
    renderNode: (props: nodeProps) => {
      if (props.node.type === options.tagsType) {
        return tagsNode()(props)
      } else if (props.node.type === options.tagType) {
        return tagNode()(props)
      }
    }
  }
}

export default TagPlugin
