import React, { Component } from 'react'
import Container from 'components/container'

import styles from './styles'

export default class Modal extends Component {
  dialogNode = null

  render () {
    return (
      <dialog
        id='modal'
        className={styles.modal}
        ref={node => (this.dialogNode = node)}
      >
        <Container>
          <span
            className={styles.close}
            onClick={() => this.props.hideDialog()}
          >
            &#10005;
          </span>
          <div>{this.props.children}</div>
        </Container>
      </dialog>
    )
  }
}
