import { ITALIC } from 'editor/constants/marks'
import markPlugin from './mark'

const ItalicPlugin = opt => {
  const options = Object.assign(
    {
      type: ITALIC,
      tagName: 'i'
    },
    opt
  )

  return markPlugin(options, 'cmd+i')
}

export default ItalicPlugin
