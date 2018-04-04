import React from 'react'
import Container from 'components/container'
import styles from './styles/marketing'

const MarketingHeader = props => (
  <header>
    <Container>
      <nav class={styles.nav}>
        <div class={styles.logo}>
          <a href='/' class={styles.logoLink}>
            Chuspace
          </a>
        </div>
        <div class={styles.links}>
          <a class={styles.link} href='/'>
            Sign in
          </a>
        </div>
      </nav>
    </Container>
  </header>
)

export default MarketingHeader
