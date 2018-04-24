// @flow

import { EMOJI } from 'editor/constants/inlines'
import emojiNode from 'editor/renderers/emojiNode'
import nodeAttrs from 'editor/attributes/node'

const EmojiPlugin = () => {
  const options = Object.assign({
    type: EMOJI,
    getEmoji: node => node.data.get('code'),
    ...nodeAttrs
  })

  return {
    renderNode: (props: nodeProps) => {
      if (props.node.type === options.type) return emojiNode(options)(props)
    }
  }
}

export default EmojiPlugin
