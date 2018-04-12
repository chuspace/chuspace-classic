// @flow

import React, { Fragment } from 'react'
import classNames from 'classnames'

type Props = {
  placeholder?: string,
  autoFocus?: boolean,
  type: string,
  helpText?: string,
  className?: string,
  name?: string
}

const Input = (props: Props) => (
  <Fragment>
    <input
      autoComplete='off'
      placeholder={props.placeholder}
      autoFocus={props.autoFocus}
      className={classNames(
        'f6 ba b--light-green pa2 w-100 br2 db mb2 input-reset',
        props.className
      )}
      type={props.type}
      name={props.name}
    />
    {props.helpText && (
      <small className='tl f6 black-60 db mb2'>{props.helpText}</small>
    )}
  </Fragment>
)

Input.defaultProps = {
  autoFocus: false,
  type: 'text',
  helpText: ''
}

export default Input
