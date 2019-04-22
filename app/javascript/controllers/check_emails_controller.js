// @flow

import * as Rails from 'rails-ujs'

import { Controller } from 'stimulus'
import debounce from 'lodash/debounce'
import isEmpty from 'lodash/isEmpty'
import withForm from 'helpers/form'

export default
@withForm
class CheckEmails extends Controller {
  static inputs = ['inputEmail']
  static errors = ['inputEmailError']

  check(e: SyntheticInputEvent<HTMLInputElement>) {
    const email = this.inputEmailTarget.value
    if (isEmpty(email)) return

    Rails.ajax({
      type: 'POST',
      url: e.target.dataset.url,
      data: `email=${this.inputEmailTarget.value}`,
      success: data => this.resetErrors(),
      error: data => {
        if (data.errors && data.errors.length > 0) {
          this.resetErrors()
          this.setFormErrors(data.errors)
          return
        }
      }
    })
  }

  call = debounce(this.check, 300)
}
