import React, { Component } from 'react'

export default class Card extends Component {
  dialogNode = null

  render () {
    return (
      <dialog
        id='modal'
        className='modal bn br2 pv4 shadow-3 w-50 center bg-light-green'
        ref={node => (this.dialogNode = node)}
      >
        <div className='modal-body tc w-70 center'>
          <span
            className='modal-close absolute top-1 right-1 pointer'
            onClick={this.props.hide}
          >
            &#10005;
          </span>
          <div>{this.props.children}</div>
        </div>
      </dialog>
    )
  }
}
