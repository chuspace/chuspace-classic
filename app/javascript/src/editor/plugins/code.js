// @flow

import { CODE } from 'editor/constants/marks'
import markPlugin from './mark'

const CodePlugin = () => {
  const options = Object.assign({
    type: CODE,
    tagName: 'code'
  })

  return markPlugin(options, 'cmd+`')
}

export default CodePlugin
