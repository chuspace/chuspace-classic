import React, { Component } from 'react'

import Modal from 'components/modal'

export default class Login extends Component {
  state = {
    hidden: false,
    form: false
  }

  hide = e => {
    e.preventDefault()
    this.setState({ hidden: true })
  }

  showForm = e => {
    e.preventDefault()
    this.setState({ form: true })
  }

  reset = e => {
    e.preventDefault()
    this.setState({ form: false })
  }

  renderForm = () => (
    <div className='login-form'>
      <h2 className='f2 lh-title'>Sign in with email</h2>
      <p className='intro f5 lh-copy'>
        Enter the email address associated with your account, and we’ll send a
        magic link to your inbox.
      </p>

      <div className='form'>
        <input type='text' />
        <a href='#' onClick={this.reset}>
          All sign in options
        </a>
      </div>
    </div>
  )

  renderActions = () => (
    <div className='login-actions'>
      <h2 className='f2 lh-title'>Welcome back</h2>
      <p className='intro f5 lh-copy'>
        Sign in to access your personalized homepage, follow authors and topics
        you love, and clap for stories that matter to you.
      </p>
      <div className='actions'>
        <a href='/auth/github'>Sign in with github</a>
        <a href='#' onClick={this.showForm}>
          Sign in with email
        </a>
      </div>
    </div>
  )

  render () {
    return (
      <Modal {...this.props} hidden={this.state.hidden} hide={this.hide}>
        {this.state.form ? this.renderForm() : this.renderActions()}
      </Modal>
    )
  }
}
