import React, { Component } from 'react'

export default class Modal extends Component {
  dialogNode = null

  render () {
    return (
      <dialog
        id='modal'
        className='modal mw6 center'
        ref={node => (this.dialogNode = node)}
      >
        <div className='modal-body'>
          <span className='modal-close' onClick={() => this.props.hideDialog()}>
            &#10005;
          </span>
          <div>{this.props.children}</div>
        </div>
      </dialog>
    )
  }
}
