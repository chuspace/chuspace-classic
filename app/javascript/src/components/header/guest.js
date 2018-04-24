// @flow

import React, { Component } from 'react'

import type { ComponentType } from 'react'
import GettingStarted from 'decorators/getting-started'
import Link from 'components/link'
import LinkButton from 'components/link-button'

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
      showLogin
    } = this.props

    return (
      <div className='nav-links flex items-center'>
        <Link title='Sign in' className='mr4' onClick={showLogin} />
        <LinkButton title='Get Started' onClick={showSignup} />

        {this.props.signup && (
          <Registration
            {...this.props}
          />
        )}

        {this.props.login && (
          <Login
            {...this.props}
          />
        )}
      </div>
    )
  }
}
