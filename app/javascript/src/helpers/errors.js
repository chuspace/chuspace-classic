// @flow

import type { PayloadError } from 'react-relay'
import capitalize from 'lodash/capitalize'
import toSentence from 'helpers/to-sentence'

export const parseValidationErrors = (errors: Array<PayloadError>) => {
  let formErrors: { [string]: string } = {}

  errors.forEach(({ field, messages }) => {
    formErrors[field] = capitalize(`${toSentence(messages)}`)
  })

  return formErrors
}
