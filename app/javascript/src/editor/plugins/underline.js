// @flow

import { UNDERLINE } from 'editor/constants/marks'
import markPlugin from 'editor/plugins/mark'

const UnderlinePlugin = opt => {
  const options = Object.assign(
    {
      type: UNDERLINE,
      tagName: 'u'
    },
    opt
  )

  return markPlugin(options, 'cmd+u')
}

export default UnderlinePlugin
