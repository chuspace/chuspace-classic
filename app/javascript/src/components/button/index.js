// @flow

import React from 'react'
import classNames from 'classnames'

type Props = {
  title: string,
  className?: string,
  onClick?: (evt: SyntheticEvent<HTMLButtonElement>) => void
}

const Button = (props: Props) => (
  <button
    onClick={props.onClick}
    className={classNames(
      'pointer ba b--light-green pa2 br2 db mw5 no-underline outline-0',
      props.className
    )}
  >
    {props.title}
  </button>
)

export default Button
