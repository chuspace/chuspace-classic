// @flow

import * as Rails from 'rails-ujs'

import { Controller } from 'stimulus'
import debounce from 'lodash/debounce'
import isEmpty from 'lodash/isEmpty'
import withForm from 'helpers/form'

export default
@withForm
class CheckNicknames extends Controller {
  static inputs = ['inputNickname']
  static errors = ['inputNicknameError']

  check(e: SyntheticInputEvent<HTMLInputElement>) {
    const nickname = this.inputNicknameTarget.value
    if (isEmpty(nickname)) return

    Rails.ajax({
      type: 'POST',
      url: e.target.dataset.url,
      data: `nickname=${this.inputNicknameTarget.value}`,
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
