import React, { Component } from 'react'

export default class Card extends Component {
  dialogNode = null

  render () {
    return (
      <dialog
        id='modal'
        className='modal bn br2 shadow-3 mw7 center'
        ref={node => (this.dialogNode = node)}
      >
        <div className='modal-body tc pa4 w-70 center'>
          <span className='modal-close' onClick={() => this.props.hide()}>
            &#10005;
          </span>
          <div>{this.props.children}</div>
        </div>
      </dialog>
    )
  }
}
