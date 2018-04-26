// @flow

import { UNDERLINE } from 'editor/constants/marks'
import markPlugin from 'editor/plugins/mark'

const UnderlinePlugin = () => {
  const options = Object.assign({
    type: UNDERLINE,
    tagName: 'u'
  })

  return markPlugin(options, 'cmd+u')
}

export default UnderlinePlugin
