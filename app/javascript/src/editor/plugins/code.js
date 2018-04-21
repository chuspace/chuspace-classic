import markPlugin from './mark'
import { CODE } from 'editor/constants/marks'

const CodePlugin = () => {
  const options = Object.assign(
    {
      type: CODE,
      tagName: 'code'
    }
  )

  return markPlugin(options, 'cmd+`')
}

export default CodePlugin
