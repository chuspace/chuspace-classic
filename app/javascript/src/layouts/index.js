import React, { Component } from 'react'

import Container from 'components/container'

import styles from './styles'
import './global.css'

export default class MarketingLayout extends Component {
  render () {
    return (
      <div className={styles.layout}>
        <header>
          <Container>
            <nav class={styles.nav}>
              <div class={styles.logo}>
                <a href='/' class='logo-link'>
                  logo
                </a>
              </div>
              <div class={styles.links}>
                <a class={styles.link} href='/' >How it Works</a>
                <a class={styles.link} href='/' >Pricing</a>
                <a class={styles.link} href='/' >About</a>
                <a class={styles.link} href='/' >Careers</a>
                <a class={styles.link} href='/' >Sign Up</a>
              </div>
            </nav>
          </Container>
        </header>

        {this.props.children}

        <footer>
          I am footer
        </footer>
      </div>
    )
  }
}
