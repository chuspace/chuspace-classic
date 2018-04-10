// @flow

import React, { Component } from 'react'

import Modal from 'components/modal'
import Input from 'components/input'
import Button from 'components/button'
import LinkButton from 'components/link-button'
import Link from 'components/link'

type Props = {
  showLogin: () => void,
  hideSignup: () => void
}

type State = {
  form: boolean
}

export default class Registration extends Component<Props, State> {
  state = {
    form: false
  }

  showLogin = (e: SyntheticEvent<HTMLButtonElement>) => {
    this.props.showLogin()
    this.props.hideSignup()
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
    <div className='registration-form'>
      <h2 className='f2 lh-title'>Sign up with email</h2>
      <p className='intro f5 lh-copy'>
        Enter the email address associated with your account, and we’ll send a
        magic link to your inbox.
      </p>

      <div className='form'>
        <Input name='name' autoFocus />
        <Input name='email' />
        <Button title='Submit' className='center' />
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
    <div className='registration-actions'>
      <h2 className='f2 lh-title'>Join Chuspace</h2>
      <p className='intro f5 lh-copy'>
        Create an account to personalize your homepage, follow your favorite
        authors and publications, applaud stories you love, and more.
      </p>
      <div className='actions mt4'>
        <LinkButton
          className='center mb2'
          title='Sign up with github'
          href='/auth/github'
        />
        <LinkButton
          className='center'
          title='Sign up with email'
          href='#'
          onClick={this.showForm}
        />
      </div>
      <p className='mt4'>
        Already have an account?{' '}
        <Link
          title='Sign in'
          className='dib dark-green bb b--dark-green pb1'
          onClick={this.showLogin}
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
