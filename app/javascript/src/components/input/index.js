import React from 'react'

const Input = props => (
  <input
    autoFocus
    className='center ba b--light-gray pa2 br2 db w5 mb2 input-reset'
    type={props.type || 'text'}
    name={props.name}
  />
)

export default Input
