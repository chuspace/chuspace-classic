import React from 'react'
import classnames from 'classnames'

import styles from './styles'

const Container = (props) => (
  <div className={classnames(
    styles[props.size || 'mw8'], {
      [styles.center]: props.center || true
    }
  )}>
    {props.children}
  </div>
)

export default Container
