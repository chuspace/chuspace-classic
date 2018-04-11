// @flow

import React from 'react'
import classNames from 'classnames'

type Props = {
  placeholder?: string,
  autoFocus?: boolean,
  type: string,
  className?: string,
  name?: string
}

const Input = (props: Props) => (
  <input
    autoComplete='off'
    placeholder={props.placeholder}
    autoFocus={props.autoFocus}
    className={classNames(
      'f6 center ba b--light-green pa2 br2 db w5 mb2 input-reset',
      props.className
    )}
    type={props.type}
    name={props.name}
  />
)

Input.defaultProps = {
  autoFocus: false,
  type: 'text'
}

export default Input
