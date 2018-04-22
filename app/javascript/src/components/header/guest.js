// @flow

import type { ComponentType } from 'react'
import React, { Component } from 'react'

import GettingStarted from 'decorators/getting-started'
import LinkButton from 'components/link-button'
import Link from 'components/link'

type Props = {
  signup: boolean,
  login: boolean,
  Registration: ComponentType<{}>,
  Login: ComponentType<{}>,
  showSignup: (*) => void,
  hideSignup: (*) => void,
  showLogin: (*) => void,
  hideLogin: (*) => void
}

@GettingStarted
export default class GuestNav extends Component<Props> {
  render () {
    const {
      Registration,
      Login,
      showSignup,
      hideSignup,
      showLogin,
      hideLogin
    } = this.props

    return (
      <div className='nav-links flex items-center'>
        <Link title='Sign in' className='mr4' onClick={showLogin} />
        <LinkButton title='Get Started' onClick={showSignup} />

        {this.props.signup && (
          <Registration
            {...this.props}
            hide={hideSignup}
            hideSignup={hideSignup}
            showLogin={showLogin}
          />
        )}

        {this.props.login && (
          <Login
            {...this.props}
            hide={hideLogin}
            hideLogin={hideLogin}
            showSignup={showSignup}
          />
        )}
      </div>
    )
  }
}
