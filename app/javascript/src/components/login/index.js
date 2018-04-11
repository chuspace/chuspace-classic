// @flow

import React, { Component } from 'react'

import Modal from 'components/modal'
import Input from 'components/input'
import Button from 'components/button'
import Link from 'components/link'
import LinkButton from 'components/link-button'

type Props = {
  showSignup: () => void,
  hideLogin: () => void
}

type State = {
  form: boolean
}

export default class Login extends Component<Props, State> {
  state = {
    form: false
  }

  showRegistration = (e: SyntheticEvent<HTMLButtonElement>) => {
    this.props.showSignup()
    this.props.hideLogin()
  }

  showForm = (e: SyntheticEvent<HTMLButtonElement>) => {
    e.preventDefault()
    this.setState({ form: true })
  }

  reset = (e: SyntheticEvent<HTMLButtonElement>) => {
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
        <Input name='email' autoFocus />
        <Button title='Submit' className='center bg-black white bn mt3' />
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
        <LinkButton
          className='center mb2 bg-white black'
          title='Sign in with github'
          href='/auth/github'
        />
        <LinkButton
          className='center mb2 bg-white black'
          title='Sign in with email'
          href='#'
          onClick={this.showForm}
        />
      </div>
      <p className='mt4'>
        No account?{' '}
        <Link
          className='dib dark-green bb b--dark-green pb1'
          title='Join'
          onClick={this.showRegistration}
        />
      </p>
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
