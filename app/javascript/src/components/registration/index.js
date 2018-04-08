import React, { Component } from 'react'

import Modal from 'components/modal'

export default class Registration extends Component {
  state = {
    hidden: false
  }

  render () {
    return (
      <Modal {...this.props} hidden={this.state.hidden}>
        <h1 className='f1'>Join Chuspace</h1>
        <p className='intro'>
          Create an account to personalize your homepage, follow your favorite
          authors and publications, applaud stories you love, and more.
        </p>
        <div className='actions'>
          <a href='/auth/github'>Signup with github</a>
          <a href='#' onClick={this.renderForm}>
            Signup with email
          </a>
        </div>
      </Modal>
    )
  }
}
