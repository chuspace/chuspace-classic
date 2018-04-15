// @flow

import React from 'react'
import classNames from 'classnames'
import withInputDecorator from 'decorators/input-decorator'

type Props = {
  placeholder?: string,
  autoFocus?: boolean,
  onChange?: (e: SyntheticEvent<HTMLInputElement>) => void,
  helpText?: string,
  className?: string,
  rows?: number,
  name: string,
  value?: string,
  error?: string,
  required?: boolean,
  defaultValue?: string
}

const Textarea = (props: Props) => (
  <textarea
    rows={props.rows}
    onChange={props.onChange}
    placeholder={props.placeholder}
    autoFocus={props.autoFocus}
    className={classNames(
      'input f6 ba b--light-green pa2 w-100 br2 db mb2 input-reset',
      props.className
    )}
    name={props.name}
    value={props.value}
    defaultValue={props.defaultValue}
  />
)

Textarea.defaultProps = {
  autoFocus: false,
  required: false,
  rows: 1,
  helpText: ''
}

export default withInputDecorator(Textarea)
