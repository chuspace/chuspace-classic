// @flow
import * as React from 'react'

import loadLanguages from 'prismjs/components/index.js'
import type { nodeProps } from 'editor/types'

export const codeBlockNode = options => {
  const CodeBlockComponent = ({ attributes, children, node }: nodeProps) => {
    let syntax = options.getSyntax(node) || 'TXT'

    try {
      if (syntax) loadLanguages([syntax])
    } catch (e) {
      syntax = 'TXT'
      console.log(`${syntax} syntax is not currently supported`)
    }

    return (
      <div className='relative'>
        <div
          className='absolute right-0 top-0 f6 pa1 ph2 bg-light-gray br2 mid-gray ttu'
          contentEditable={false}
        >
          {syntax}
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
