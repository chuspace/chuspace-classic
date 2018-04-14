// @flow

import React, { Component } from 'react'
import Confetti from 'react-confetti'
import sizeMe from 'react-sizeme'

import Modal from 'components/modal'
import Input from 'components/input'
import Button from 'components/button'
import LinkButton from 'components/link-button'
import Link from 'components/link'
import RelayClient from 'helpers/relay-client'
import { parseValidationErrors } from 'helpers/errors'

import CreateNewUserMutation from 'mutations/users/create-user'

type Props = {
  showLogin: () => void,
  hideSignup: () => void,
  size: {
    width: number,
    height: number
  }
}

type State = {
  showForm: boolean,
  submitting: boolean,
  success: boolean,
  errors: {
    name: string,
    email: string,
    nickname: string
  },
  form: {
    name: string,
    email: string,
    nickname: string
  }
}

@sizeMe({
  monitorHeight: true,
  monitorWidth: true,
  noPlaceholder: true
})
export default class Registration extends Component<Props, State> {
  static Form = {
    email: '',
    nickname: '',
    name: ''
  }

  formNode: ?HTMLFormElement

  state = {
    showForm: false,
    submitting: false,
    success: false,
    form: Registration.Form,
    errors: Registration.Form
  }

  handleInputChange = (e: SyntheticEvent<HTMLInputElement>) => {
    const form = { ...this.state.form }
    form[e.currentTarget.name] = e.currentTarget.value
    this.setState({ form, errors: Registration.Form })
  }

  handleSubmit = (e: SyntheticEvent<HTMLFormElement>) => {
    e.preventDefault()
    RelayClient.commitMutation({
      mutation: CreateNewUserMutation,
      variables: {
        input: this.state.form
      },
      onCompleted: ({ create_user: response }, errors) => {
        if (response.errors) {
          const parsedErrors = parseValidationErrors(response.errors)
          this.setState({ errors: parsedErrors })
          return
        }

        if (response.user.id) {
          /* $FlowFixMe */
          this.formNode.reset()
          this.setState({ form: Registration.Form, success: true }, () =>
            setTimeout(() => this.props.hideSignup(), 5000)
          )
        }
      },
      onError: err => {
        this.setState({ form: Registration.Form })
        /* $FlowFixMe */
        this.formNode.reset()
        console.log('i run error')
        console.error(err)
      }
    })
  }

  showLogin = (e: SyntheticEvent<HTMLButtonElement>) => {
    this.props.showLogin()
    this.props.hideSignup()
  }

  showForm = (e: SyntheticEvent<HTMLButtonElement>) => {
    e.preventDefault()
    this.setState({ showForm: true })
  }

  reset = (e: SyntheticEvent<HTMLButtonElement>) => {
    e.preventDefault()
    this.setState({ showForm: false })
  }

  renderSuccess = () => (
    <div className='pa3 bg-light-yellow'>
      <p className='intro f5 lh-copy'>
        Horray! Welcome. We have sent you a link to login.
      </p>
    </div>
  )

  renderForm = () => (
    <form
      className='form measure center w-60'
      onSubmit={this.handleSubmit}
      ref={node => (this.formNode = node)}
    >
      <Input
        autoComplete='name'
        onChange={this.handleInputChange}
        name='name'
        value={this.state.form.name}
        error={this.state.errors.name}
        placeholder='Full name'
        autoFocus
      />
      <Input
        onChange={this.handleInputChange}
        name='nickname'
        error={this.state.errors.nickname}
        value={this.state.form.nickname}
        placeholder='Username'
      />
      <Input
        autoComplete='email'
        onChange={this.handleInputChange}
        error={this.state.errors.email}
        name='email'
        value={this.state.form.email}
        placeholder='Email'
      />
      <Button
        title='Submit'
        disabled={this.state.submitting}
        className='center bg-black white bn mt3'
      />
    </form>
  )

  renderRegistration = () => (
    <div className='registration-form'>
      <h2 className='f2 lh-title'>Sign up with email</h2>
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
      <Modal {...this.props} className='brand-bg-green'>
        {this.state.success && (
          <Confetti {...this.props.size} recycle={false} />
        )}
        {this.state.showForm ? this.renderRegistration() : this.renderActions()}
      </Modal>
    )
  }
}
