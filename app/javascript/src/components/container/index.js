import React from 'react'
import classnames from 'classnames'

import styles from './styles'

const Container = (props) => {
  return (
    <div className={styles[props.size || 'regular']}>
      {props.children}
    </div>
  )
}

export default Container
