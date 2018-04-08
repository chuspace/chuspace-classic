import React from 'react'
import classNames from 'classnames'

const Link = props => (
  <a
    onClick={props.onClick}
    className={classNames('black-90 db no-underline pointer', props.className)}
    href={props.href}
  >
    {props.title}
  </a>
)

export default Link
