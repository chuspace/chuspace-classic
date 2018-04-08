import React from 'react'

const Button = props => (
  <button className='bg-white hover-bg-near-white shadow-5 black-90 pointer ba b--light-gray pa2 br2 db mw5 no-underline mb2 center outline-0'>
    {props.title}
  </button>
)

export default Button
