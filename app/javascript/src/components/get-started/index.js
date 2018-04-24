// @flow

import React, { Component, Fragment } from 'react'

import type { ComponentType } from 'react'
import GettingStarted from 'decorators/getting-started'
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
export default class GetStarted extends Component<Props> {
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
      <Fragment>
        <LinkButton
          title='Get Started'
          onClick={showSignup}
          className='center mv4 bg-white hover-bg-white-80'
        />

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
      </Fragment>
    )
  }
}
