// @flow

import React from 'react'
import classNames from 'classnames'

type Props = {
  title: string,
  className?: string,
  href?: string,
  onClick?: (evt: SyntheticEvent<HTMLButtonElement>) => void
}

const Link = (props: Props) => (
  <a
    onClick={props.onClick}
    className={classNames('black-90 no-underline pointer', props.className)}
    href={props.href}
  >
    {props.title}
  </a>
)

export default Link
