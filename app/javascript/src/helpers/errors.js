// @flow

import capitalize from 'lodash/capitalize'
import toSentence from 'helpers/to-sentence'

export const parseValidationErrors = (errors: {
  [string]: string | Array<string>
}): { [string]: string } => {
  let formErrors = {}
  let message: any

  Object.entries(errors).forEach(
    ([key: string, value: Array<string> | string]) => {
      message = value

      if (Array.isArray(value)) {
        message = capitalize(`${toSentence(value)}`)
      }

      formErrors[key] = message
    }
  )

  return formErrors
}
