// @flow

import React from 'react'
import withInputDecorator from 'decorators/input-decorator'

type Props = {
  placeholder?: string,
  autoFocus?: boolean,
  onChange?: (e: SyntheticEvent<HTMLInputElement>) => void,
  helpText?: string,
  className?: string,
  name: string,
  value?: string,
  error?: string,
  defaultValue?: string,
  required?: boolean,
  children?: () => Node
}

const Select = (props: Props) => (
  <select
    className='input f6 ba b--light-green pa2 w-100 br2 db mb2 input-reset'
    name={props.name}
    value={props.value}
    onChange={props.onChange}
    required={props.required}
    defaultValue={props.defaultValue}
  >
    {props.children}
  </select>
)

Select.defaultProps = {
  required: false
}

export default withInputDecorator(Select)
