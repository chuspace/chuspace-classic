// @flow

import { STRIKETHROUGH } from 'editor/constants/marks'
import markPlugin from 'editor/plugins/mark'

const StrikeThroughPlugin = opt => {
  const options = Object.assign(
    {
      type: STRIKETHROUGH,
      tagName: 's'
    },
    opt
  )

  return markPlugin(options, 'ctrl+opt+d')
}

export default StrikeThroughPlugin
