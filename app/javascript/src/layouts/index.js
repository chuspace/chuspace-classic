import React, { Component } from 'react'

import MarketingHeader from 'components/header/marketing'
import MarketingFooter from 'components/footer/marketing'

import styles from './styles'
import './global.css'

export default class MarketingLayout extends Component {
  render () {
    return (
      <div className={styles.layout}>
        <MarketingHeader />
        {this.props.children}
        <MarketingFooter />
      </div>
    )
  }
}
