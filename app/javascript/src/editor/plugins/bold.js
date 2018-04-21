// @flow

import markPlugin from './mark'
import { BOLD } from 'editor/constants/marks'

const BoldPlugin = () => {
  const options = Object.assign(
    {
      type: BOLD,
      tagName: 'strong'
    }
  )

  return markPlugin(options, 'cmd+b')
}

export default BoldPlugin
