import React from 'react'

const LinkButton = props => (
  <a
    onClick={props.onClick}
    className='bg-white hover-bg-near-white shadow-5 black-90 ba b--light-gray pa2 br2 db mw5 no-underline mb2 center outline-0'
    href={props.href}
  >
    {props.title}
  </a>
)

export default LinkButton
