// @flow
import * as React from 'react'
import type { Change } from 'slate'

export default function (options) {
  const NodeComponent = ({ ...props }: nodeProps) => {
    return <ImageNode {...props} {...options} />
  }
  return NodeComponent
}

type Props = nodeProps & {
  change: Change,
  editor: Object,
  readOnly: Boolean
}

class ImageNode extends React.Component<Props> {
  render () {
    const { node, getSrc, getWidth, getHeight } = this.props
    const src = getSrc(node)
    const nodeWidth = getWidth(node)
    const nodeHeight = getHeight(node)

    return (
      <img src={src} width={nodeWidth} height={nodeHeight} />
    )
  }
}
