// @flow

import type { ComponentType } from 'react'
import React, { Fragment } from 'react'
import octicons from 'octicons'

type Props = {
  autoComplete?: string,
  label?: string,
  className?: string,
  required?: boolean,
  helpText?: string,
  value?: string,
  defaultValue?: string,
  onChange?: (e: SyntheticEvent<HTMLInputElement>) => void,
  name: string,
  error?: string,
  autoFocus?: boolean,
  placeholder?: string,
  rows?: number,
  type?: string,
  children?: () => Node
}

const withInputDecorator = (Component: ComponentType<Props>) => (
  props: Props
) => {
  return (
    <div className='relative mt3'>
      {props.label && (
        <label htmlFor={props.name} className='f6 b db mb2'>
          {props.label}{' '}
          {!props.required && (
            <span className='normal black-60'>(optional)</span>
          )}
        </label>
      )}
      <Component {...props} />
      <Fragment>
        {props.value &&
          (props.error ? (
            <div
              className='input-icon absolute right-1'
              dangerouslySetInnerHTML={{
                __html: octicons.alert.toSVG({ class: 'fill-red' })
              }}
            />
          ) : (
            <div
              className='input-icon absolute right-1'
              dangerouslySetInnerHTML={{
                __html: octicons.check.toSVG({ class: 'fill-green' })
              }}
            />
          ))}
        {props.error && (
          <small className='tl f6 red db mb2'>{props.error}</small>
        )}
      </Fragment>
      {props.helpText && (
        <small className='tl f6 black-60 db mb2'>{props.helpText}</small>
      )}
    </div>
  )
}

export default withInputDecorator
