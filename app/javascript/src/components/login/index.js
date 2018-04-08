import React, { Component } from 'react'

import Modal from 'components/modal'
import Input from 'components/input'
import Button from 'components/button'
import LinkButton from 'components/link-button'

export default class Login extends Component {
  state = {
    form: false
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
        <Input name='email' />
        <Button title='Submit' />
      </div>

      <a
        className='black-90 center mt3 db no-underline f6 lh-copy'
        href='#'
        onClick={this.reset}
      >
        ← Go back
      </a>
    </div>
  )

  renderActions = () => (
    <div className='login-actions'>
      <h2 className='f2 lh-title'>Welcome back</h2>
      <p className='intro f5 lh-copy'>
        Sign in to access your personalized homepage, follow authors and topics
        you love, and clap for stories that matter to you.
      </p>
      <div className='actions mt4'>
        <LinkButton title='Sign in with github' href='/auth/github' />
        <LinkButton
          title='Sign in with email'
          href='#'
          onClick={this.showForm}
        />
      </div>
    </div>
  )

  render () {
    return (
      <Modal {...this.props}>
        {this.state.form ? this.renderForm() : this.renderActions()}
      </Modal>
    )
  }
}
