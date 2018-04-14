// @flow

import type { Node } from 'react'
import React, { Component } from 'react'
import classNames from 'classnames'
import octicons from 'octicons'

type Props = {
  hide: boolean,
  className?: string,
  children: Node
}

export default class Card extends Component<Props> {
  dialogNode: null | HTMLElement = null

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
            onClick={this.props.hide}
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
