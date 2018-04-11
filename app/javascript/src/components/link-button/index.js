// @flow

import React from 'react'
import classNames from 'classnames'

type Props = {
  title: string,
  className?: string,
  href?: string,
  onClick?: (evt: SyntheticEvent<HTMLButtonElement>) => void
}

const LinkButton = (props: Props) => (
  <a
    onClick={props.onClick}
    className={classNames(
      'ba b--light-green pointer pa2 br2 db mw5 no-underline outline-0',
      props.className
    )}
    href={props.href}
  >
    {props.title}
  </a>
)

export default LinkButton
