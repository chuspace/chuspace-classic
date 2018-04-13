// @flow

import React, { Component } from 'react'
import omit from 'lodash/omit'

import Modal from 'components/modal'
import Input from 'components/input'
import Button from 'components/button'
import LinkButton from 'components/link-button'
import Link from 'components/link'
import RelayClient from 'helpers/relay-client'

import CreateNewUserMutation from 'mutations/users/create-user'

type Props = {
  showLogin: () => void,
  hideSignup: () => void
}

type State = {
  form: boolean,
  name: string,
  email: string,
  nickname: string
}

export default class Registration extends Component<Props, State> {
  state = {
    form: false,
    email: '',
    nickname: '',
    name: ''
  }

  handleInputChange = (e: SyntheticEvent<HTMLInputElement>) =>
    this.setState({ [e.currentTarget.name]: e.currentTarget.value })

  handleSubmit = (e: SyntheticEvent<HTMLFormElement>) => {
    e.preventDefault()
    RelayClient.commitMutation({
      mutation: CreateNewUserMutation,
      variables: {
        input: omit(this.state, ['form'])
      },
      onCompleted: (response, errors) => {
        console.log('Response received from server.', response, errors)
      },
      onError: err => console.error(err)
    })
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

      <form className='form measure center w5' onSubmit={this.handleSubmit}>
        <Input
          autoComplete='name'
          onChange={this.handleInputChange}
          name='name'
          placeholder='Full name'
          autoFocus
        />
        <Input
          autoComplete='off'
          onChange={this.handleInputChange}
          name='nickname'
          placeholder='Username'
        />
        <Input
          autoComplete='email'
          onChange={this.handleInputChange}
          name='email'
          placeholder='Email'
        />
        <Button title='Submit' className='center bg-black white bn mt3' />
      </form>

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
          className='center mb2 bg-white black'
          title='Sign up with github'
          href='/auth/github'
        />
        <LinkButton
          className='center bg-white black'
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
