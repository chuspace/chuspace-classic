// @flow
import * as React from 'react'

import type { nodeProps } from 'editor/types'
import octicons from 'octicons'

export default function Tag () {
  const TagNode = ({ attributes, children, node }: nodeProps) => {
    return (
      <span
        {...attributes}
        style={{ minWidth: '6rem' }}
        data-slate-type='tag'
        className='fl mr2 relative f6 ba pl3 pv2 b--light-gray dib pr4'
      >
        {children}
        <div
          style={{ top: 10, right: 10 }}
          className='f6 fr absolute'
          dangerouslySetInnerHTML={{
            __html: octicons.x.toSVG({ fill: '#666', width: 8 })
          }}
        />
      </span>
    )
  }

  TagNode.displayName = `tag-node`

  return TagNode
}
