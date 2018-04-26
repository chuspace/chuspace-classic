// @flow

import { ITALIC } from 'editor/constants/marks'
import markPlugin from './mark'

const ItalicPlugin = () => {
  const options = Object.assign({
    type: ITALIC,
    tagName: 'i'
  })

  return markPlugin(options, 'cmd+i')
}

export default ItalicPlugin
