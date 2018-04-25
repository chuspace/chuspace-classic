// @flow
import * as React from 'react'

import loadLanguages from 'prismjs/components/index.js'

export const codeBlockNode = options => {
  const CodeBlockComponent = ({ attributes, children, node }: nodeProps) => {
    const syntax = options.getSyntax(node)
    if (syntax) loadLanguages([syntax])

    return (
      <div className='relative'>
        <div
          className='absolute right-0 top-0 f6 pa1 ph2 bg-light-gray br2 mid-gray ttu'
          contentEditable={false}
        >
          {syntax || 'TXT'}
        </div>
        <pre>
          <code {...attributes}>{children}</code>
        </pre>
      </div>
    )
  }

  CodeBlockComponent.displayName = 'codeblock-node'

  return CodeBlockComponent
}

export const codeLineNode = () => {
  const CodeLineComponent = ({ attributes, children }: nodeProps) => {
    return <div {...attributes}>{children}</div>
  }

  CodeLineComponent.displayName = 'codeline-node'

  return CodeLineComponent
}
