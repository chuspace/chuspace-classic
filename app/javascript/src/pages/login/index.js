import React, { Component } from 'react'

import Container from 'components/container'
import Input from 'components/form/input'
import styles from './styles'

class Login extends Component {
  render () {
    return (
      <Container size='small'>
        <div className={styles.login}>
          <h1>Login</h1>
          <Input type='text' placeholder='Email' />
          <Input type='password' placeholder='Password' />
        </div>
      </Container>
    )
  }
}

export default Login
