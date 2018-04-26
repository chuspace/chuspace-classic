// @flow
import * as React from 'react'

export default function ({ getHref }) {
  const EmbedNode = ({ attributes, children, node }: nodeProps) => {
    return (
      <a
        {...attributes}
        href={getHref(node)}
        className='embedly-card'
        data-slate-type='html'
        data-card-key='227fa5d8a5cc4ccba3db93b52b1a5238'
      >
        {children}
      </a>
    )
  }

  EmbedNode.displayName = `html-node`

  return EmbedNode
}
