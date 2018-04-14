// @flow

import React, { Component } from 'react'

import Modal from 'components/modal'
import Input from 'components/input'
import Button from 'components/button'
import Link from 'components/link'
import LinkButton from 'components/link-button'

import RelayClient from 'helpers/relay-client'
import { parseValidationErrors } from 'helpers/errors'

import CreateNewLoginMutation from 'mutations/logins/create-login'

type Props = {
  showSignup: () => void,
  hideLogin: () => void
}

type State = {
  showForm: boolean,
  success: boolean,
  errors: {
    email: string
  },
  form: {
    email: string
  }
}

export default class Login extends Component<Props, State> {
  static Form = {
    email: ''
  }

  formNode = null

  state = {
    showForm: false,
    success: false,
    form: Login.Form,
    errors: Login.Form
  }

  handleInputChange = (e: SyntheticEvent<HTMLInputElement>) => {
    const form = { ...this.state.form }
    form[e.currentTarget.name] = e.currentTarget.value
    this.setState({ form, errors: Login.Form })
  }

  showRegistration = (e: SyntheticEvent<HTMLButtonElement>) => {
    this.props.hideLogin()
    this.props.showSignup()
  }

  handleSubmit = (e: SyntheticEvent<HTMLFormElement>) => {
    e.preventDefault()
    RelayClient.commitMutation({
      mutation: CreateNewLoginMutation,
      variables: {
        input: this.state.form
      },
      onCompleted: ({ create_login: response }, errors) => {
        if (response.errors) {
          const parsedErrors = parseValidationErrors(response.errors)
          this.setState({ errors: parsedErrors })
          return
        }

        if (response.user.id) {
          /* $FlowFixMe */
          this.formNode.reset()
          this.setState({ form: Login.Form, success: true }, () =>
            setTimeout(() => this.props.hideLogin(), 5000)
          )
        }
      },
      onError: err => {
        this.setState({ form: Login.Form })
        /* $FlowFixMe */
        this.formNode.reset()
        console.log('i run error')
        console.error(err)
      }
    })
  }

  showForm = (e: SyntheticEvent<HTMLButtonElement>) => {
    e.preventDefault()
    this.setState({ showForm: true })
  }

  reset = (e: SyntheticEvent<HTMLButtonElement>) => {
    e.preventDefault()
    this.setState({ showForm: false })
  }

  renderForm = () => (
    <form
      className='form measure center w-60'
      onSubmit={this.handleSubmit}
      ref={node => (this.formNode = node)}
    >
      <Input
        placeholder='Email'
        autoComplete='email'
        name='email'
        value={this.state.form.email}
        error={this.state.errors.email}
        onChange={this.handleInputChange}
        autoFocus
      />
      <Button title='Submit' className='center bg-black white bn mt3' />
    </form>
  )

  renderSuccess = () => (
    <div className='pa3 bg-light-yellow'>
      <p className='intro f5 lh-copy'>We have sent you a link to login.</p>
    </div>
  )

  renderLogin = () => (
    <div className='login-form'>
      <h2 className='f2 lh-title'>Sign in with email</h2>
      <p className='intro f5 lh-copy'>
        Enter the email address associated with your account, and we’ll send a
        magic link to your inbox.
      </p>

      {this.state.success ? this.renderSuccess() : this.renderForm()}

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
      <Modal {...this.props} className='brand-bg-blue'>
        {this.state.showForm ? this.renderLogin() : this.renderActions()}
      </Modal>
    )
  }
}
