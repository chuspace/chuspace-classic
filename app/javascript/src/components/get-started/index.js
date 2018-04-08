import React, { Component } from 'react'

import LinkButton from 'components/link-button'
import Link from 'components/link'

export default class GetStarted extends Component {
  state = {
    login: false,
    signup: false
  }

  async componentDidMount () {
    const Registration = (await import('components/registration')).default
    const Login = (await import('components/login')).default
    this.setState({ Registration, Login })
  }

  showLogin = e => this.setState({ login: true })
  hideLogin = e => this.setState({ login: false })

  showSignup = e => this.setState({ signup: true })
  hideSignup = e => this.setState({ signup: false })

  render () {
    const { Registration, Login } = this.state
    return (
      <div className='nav-links flex items-center'>
        <Link
          title='Sign in'
          className='mr4'
          onClick={this.showLogin}
        />
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
