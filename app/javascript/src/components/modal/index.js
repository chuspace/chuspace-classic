import React, { Component } from 'react'
import ReactDOM from 'react-dom'

import Dialog from 'helpers/dialog'
import Card from './card'

const modalNode = document.getElementById('modal-root')

export default class Modal extends Component {
  constructor (props) {
    super(props)
    this.el = document.createElement('div')
  }

  componentWillUnmount = () => modalNode.removeChild(this.el)

  componentDidMount () {
    modalNode.appendChild(this.el)
    this.dialog = new Dialog({ domNodeId: this.node.dialogNode.id })
    this.dialog.show()
  }

  render = () => (
    <Card
      {...this.props}
      ref={node => (this.node = node)}
      hide={this.props.hide}
    />
  )
}
