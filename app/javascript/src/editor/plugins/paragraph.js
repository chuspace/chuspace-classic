import omit from 'lodash/omit'
import commonNode from 'editor/renderers/commonNode'
import nodeAttrs from 'editor/attributes/node'
import { PARAGRAPH } from 'editor/constants/blocks'

const ParagraphPlugin = opt => {
  const options = Object.assign(
    {
      type: PARAGRAPH,
      tagName: 'p',
      ...nodeAttrs
    },
    opt
  )

  return {
    renderNode: props => {
      if (props.node.type === options.type) {
        return commonNode(options.tagName, omit(options, ['type', 'tagName']))(
          props
        )
      }
    }
  }
}

export default ParagraphPlugin
