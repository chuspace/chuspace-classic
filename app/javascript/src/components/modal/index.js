import React, { Component } from 'react'
import ReactDOM from 'react-dom'

import Dialog from 'helpers/dialog'
import Card from './card'

const modalNode = document.getElementById('modal-root')

export default class Modal extends Component {
  static defaultProps = {
    hidden: true
  }

  constructor (props) {
    super(props)
    this.el = document.createElement('div')
  }

  componentWillUnmount = () => modalNode.removeChild(this.el)

  componentDidMount () {
    modalNode.appendChild(this.el)
    this.dialog = new Dialog({ domNodeId: this.node.dialogNode.id })
    !this.props.hidden && this.dialog.show()
  }

  componentDidUpdate () {
    this.props.hidden ? this.dialog.hide() : this.dialog.show()
  }

  render = () =>
    ReactDOM.createPortal(
      <Card
        {...this.props}
        ref={node => (this.node = node)}
        hide={this.props.hide}
      />,
      this.el
    )
}
