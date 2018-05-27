// @flow

import React, { Component } from 'react'

import Drop from 'tether-drop'
import type { Node } from 'react'

type Props = {
  hide: (e?: SyntheticEvent<HTMLButtonElement>) => void,
  className?: string,
  children: Node
}

export default class Dropdown extends Component<Props> {
  drop: null | Drop = null
  dialogNode: null | HTMLElement = null
  target: null | HTMLElement = null
  content: null | HTMLElement = null

  componentDidMount () {
    this.drop = new Drop({
      target: this.target,
      content: this.content,
      position: 'bottom center',
      openOn: undefined
    })

    this.drop.open()
  }

  componentWillUnmount () {
    this.drop && this.drop.destroy()
  }

  render () {
    return (
      <div ref={node => (this.target = node)}>
        <div ref={node => (this.content = node)}>{this.props.children}</div>
      </div>
    )
  }
}
