// @flow

import { OL_LIST, UL_LIST, LIST_ITEM } from 'editor/constants/blocks'

import nodeAttrs from 'editor/attributes/node'
import commonNode from 'editor/renderers/commonNode'

const ListPlugin = () => {
  const options = Object.assign({
    olType: OL_LIST,
    ulType: UL_LIST,
    liType: LIST_ITEM
  })

  return {
    renderNode: props => {
      if (props.node.type === options.ulType) {
        return commonNode('ul', nodeAttrs)(props)
      } else if (props.node.type === options.olType) {
        return commonNode('ol', nodeAttrs)(props)
      } else if (props.node.type === options.liType) {
        return commonNode('li', nodeAttrs)(props)
      }
    }
  }
}

export default ListPlugin
