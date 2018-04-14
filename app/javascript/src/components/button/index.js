// @flow

import React from 'react'
import classNames from 'classnames'

type Props = {
  title: string,
  className?: string,
  disabled: boolean,
  onClick?: (evt: SyntheticEvent<HTMLButtonElement>) => void
}

const Button = (props: Props) => (
  <button
    onClick={props.onClick}
    disabled={props.disabled}
    className={classNames(
      'pointer ba b--light-green pa2 br2 db mw5 no-underline outline-0',
      props.className
    )}
  >
    {props.title}
  </button>
)

Button.defaultProps = {
  disabled: false
}

export default Button
