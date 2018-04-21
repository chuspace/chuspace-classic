// @flow

import commonNode from 'editor/renderers/commonNode'
import omit from 'lodash/omit'
import isHotkey from 'is-hotkey'
import { BLOCKQUOTE } from 'editor/constants/blocks'
import blockquote from 'editor/helpers/blockquote'
import nodeAttrs from 'editor/attributes/node'

const BlockquotePlugin = () => {
  const options = {
    type: BLOCKQUOTE,
    tagName: 'blockquote',
    ...nodeAttrs
  }

  return {
    renderNode: (props: nodeProps) => {
      if (props.node.type === options.type) {
        return commonNode(options.tagName, omit(options, ['type', 'tagName']))(
          props
        )
      }
    },
    onKeyDown (event: SyntheticEvent<HTMLDivElement>, change) {
      if (isHotkey('ctrl+opt+q', event)) {
        return blockquote(change, { type: options.type })
      }
    }
  }
}

export default BlockquotePlugin
