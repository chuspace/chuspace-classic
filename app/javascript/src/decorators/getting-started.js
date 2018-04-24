// @flow

import React, { PureComponent } from 'react'

import type { ComponentType } from 'react'

type Props = {}

type State = {
  login: boolean,
  signup: boolean
}

const GettingStarted = (WrappedComponent: ComponentType<Props>) =>
  class extends PureComponent<Props, State> {
    Registration: ComponentType<Props> = () => null
    Login: ComponentType<Props> = () => null

    state = {
      login: false,
      signup: false
    }

    async componentDidMount () {
      /* $FlowFixMe */
      this.Registration = (await import('components/registration/popup')).default
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

    render = () => (
      <WrappedComponent
        {...this.state}
        {...this.props}
        Registration={this.Registration}
        Login={this.Login}
        showLogin={this.showLogin}
        hideLogin={this.hideLogin}
        showSignup={this.showSignup}
        hideSignup={this.hideSignup}
      />
    )
  }

export default GettingStarted
