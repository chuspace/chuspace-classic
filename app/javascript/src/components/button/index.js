import React from 'react'
import classNames from 'classnames'

const Button = props => (
  <button className={classNames('bg-white hover-bg-near-white shadow-5 black-90 pointer ba b--light-gray pa2 br2 db mw5 no-underline outline-0', props.className)}>
    {props.title}
  </button>
)

export default Button
