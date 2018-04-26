// @flow
import * as React from 'react'

export default function (options) {
  const LinkNode = ({ attributes, children, node }: nodeProps) => {
    return (
      <a
        {...attributes}
        href={options.getHref(node)}
        className={options.getClass(node)}
        data-slate-type='link'
      >
        {children}
      </a>
    )
  }

  LinkNode.displayName = `link-node`

  return LinkNode
}
