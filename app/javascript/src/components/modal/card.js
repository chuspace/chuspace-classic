// @flow

import React, { Component } from 'react'

import type { Node } from 'react'
import classNames from 'classnames'
import keydown from 'react-keydown'
import octicons from 'octicons'

type Props = {
  hide: (e?: SyntheticEvent<HTMLButtonElement>) => void,
  className?: string,
  children: Node
}

export default class Card extends Component<Props> {
  dialogNode: null | HTMLElement = null

  @keydown('esc')
  hide () {
    this.props.hide()
  }

  render () {
    return (
      <dialog
        id='modal'
        className={classNames(
          'modal bn br2 pv4 shadow-3 w-50 center',
          this.props.className
        )}
        ref={node => (this.dialogNode = node)}
      >
        <div className='modal-body tc w-70 center'>
          <div
            className='modal-close absolute top-1 right-1 pointer'
            onClick={this.hide.bind(this)}
            dangerouslySetInnerHTML={{
              __html: octicons.x.toSVG()
            }}
          />
          <div>{this.props.children}</div>
        </div>
      </dialog>
    )
  }
}
