// @flow

import type { ComponentType } from 'react'
import React, { Component } from 'react'

import LinkButton from 'components/link-button'
import Link from 'components/link'

type Props = {}

type State = {
  login: boolean,
  signup: boolean
}

export default class GetStarted extends Component<Props, State> {
  Registration: ComponentType<Props> = () => null
  Login: ComponentType<Props> = () => null

  state = {
    login: false,
    signup: false
  }

  async componentDidMount () {
    /* $FlowFixMe */
    this.Registration = (await import('components/registration')).default
    /* $FlowFixMe */
    this.Login = (await import('components/login')).default
  }

  showLogin = (e: SyntheticEvent<HTMLButtonElement>) =>
    this.setState({ login: true })
  hideLogin = (e: SyntheticEvent<HTMLButtonElement>) =>
    this.setState({ login: false })

  showSignup = (e: SyntheticEvent<HTMLButtonElement>) =>
    this.setState({ signup: true })
  hideSignup = (e: SyntheticEvent<HTMLButtonElement>) =>
    this.setState({ signup: false })

  render () {
    const { Registration, Login } = this

    return (
      <div className='nav-links flex items-center'>
        <Link title='Sign in' className='mr4' onClick={this.showLogin} />
        <LinkButton title='Get Started' onClick={this.showSignup} />

        {this.state.signup && (
          <Registration
            hide={this.hideSignup}
            hideSignup={this.hideSignup}
            showLogin={this.showLogin}
          />
        )}

        {this.state.login && (
          <Login
            hide={this.hideLogin}
            hideLogin={this.hideLogin}
            showSignup={this.showSignup}
          />
        )}
      </div>
    )
  }
}
