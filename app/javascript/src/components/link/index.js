import React from 'react'

const Link = props => (
  <a
    onClick={props.onClick}
    className='black-90 pa2 br2 db mw5 no-underline mb2 center outline-0'
    href={props.href}
  >
    {props.title}
  </a>
)

export default Link
