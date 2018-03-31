import React from 'react'
import styles from './styles'

const Input = props =>
  <input
    id={props.id}
    autoFocus={props.autoFocus}
    className={styles.input}
    type={props.type}
    name={props.name}
    value={props.value}
    defaultValue={props.defaultValue}
    ref={props.node}
    placeholder={props.placeholder}
    onChange={props.onChange}
    onBlur={props.onBlur}
    required={props.required}
  />

export default Input
