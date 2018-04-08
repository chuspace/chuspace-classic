import React, { Component } from 'react'

import Registration from 'components/registration'
import Login from 'components/login'

import LinkButton from 'components/link-button'
import Link from 'components/link'

export default class GetStarted extends Component {
  state = {
    login: false,
    signup: false
  }

  showLogin = e => this.setState({ login: true })
  hideLogin = e => this.setState({ login: false })

  showSignup = e => this.setState({ signup: true })
  hideSignup = e => this.setState({ signup: false })

  render () {
    console.log(this.state)
    return (
      <div className='nav-links flex'>
        <Link title='Sign in' onClick={this.showLogin} />
        <LinkButton title='Get Started' onClick={this.showSignup} />
        {this.state.signup && (
          <Registration
            hide={this.hideSignup}
            hideSignup={this.hideSignup}
            showSignup={this.showSignup}
            showLogin={this.showLogin}
          />
        )}
        {this.state.login && (
          <Login
            hide={this.hideLogin}
            hideSignup={this.hideLogin}
            showLogin={this.showLogin}
            showSignup={this.showSignup}
          />
        )}
      </div>
    )
  }
}
