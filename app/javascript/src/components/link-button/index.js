import React from 'react'
import classNames from 'classnames'

const LinkButton = props => (
  <a
    onClick={props.onClick}
    className={classNames('bg-white hover-bg-near-white shadow-5 black-90 ba b--light-gray pointer pa2 br2 db mw5 no-underline outline-0', props.className)}
    href={props.href}
  >
    {props.title}
  </a>
)

export default LinkButton
