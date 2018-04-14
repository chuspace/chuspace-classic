// @flow

import React, { Fragment } from 'react'
import classNames from 'classnames'

type Props = {
  placeholder?: string,
  autoFocus?: boolean,
  autoComplete?: string,
  type: string,
  onChange: (e: SyntheticEvent<HTMLInputElement>) => void,
  helpText?: string,
  className?: string,
  name?: string,
  value?: string,
  error?: string,
  defaultValue?: string
}

const Input = (props: Props) => (
  <div className='relative'>
    <input
      autoComplete={props.autoComplete || 'off'}
      onChange={props.onChange}
      placeholder={props.placeholder}
      autoFocus={props.autoFocus}
      className={classNames(
        'input f6 ba b--light-green pa2 w-100 br2 db mb2 input-reset',
        props.className
      )}
      type={props.type}
      name={props.name}
      value={props.value}
      defaultValue={props.defaultValue}
    />
    {props.helpText && (
      <small className='tl f6 black-60 db mb2'>{props.helpText}</small>
    )}
    {props.error && <small className='tl f6 red db mb2'>{props.error}</small>}
  </div>
)

Input.defaultProps = {
  autoFocus: false,
  type: 'text',
  helpText: ''
}

export default Input
