// @flow

import { BOLD } from 'editor/constants/marks'
import markPlugin from './mark'

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
