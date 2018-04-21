import { CODE, CODE_LINE } from 'editor/constants/blocks'
import { codeBlockNode, codeLineNode } from 'editor/renderers/codeBlockNode'

const CodeBlockPlugin = () => {
  const options = Object.assign(
    {
      codeType: CODE,
      codeLineType: CODE_LINE,
      getSyntax: node => node.data.get('syntax')
    }
  )

  return {
    renderNode: props => {
      if (props.node.type === options.codeType) {
        return codeBlockNode(options)(props)
      } else if (props.node.type === options.codeLineType) {
        return codeLineNode()(props)
      }
    }
  }
}

export default CodeBlockPlugin
