// @flow

import React from 'react'
import classNames from 'classnames'

type Props = {
  title: string,
  className?: string,
  href?: string,
  method?: string,
  rel: string,
  onClick?: (evt: SyntheticEvent<HTMLButtonElement>) => void
}

const Link = (props: Props) => (
  <a
    onClick={props.onClick}
    data-method={props.method}
    rel={props.rel}
    className={classNames('black-90 no-underline pointer', props.className)}
    href={props.href}
  >
    {props.title}
  </a>
)

Link.defaultProps = {
  ref: 'nofollow'
}

export default Link
