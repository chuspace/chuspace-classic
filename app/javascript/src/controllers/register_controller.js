// @flow

import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['actions', 'form', 'registerForm']

  onLoginSuccess (event) {
    let [data, status, xhr] = event.detail

    if (data.errors) {
      this.errorsTarget.innerHTML = data.errors.email
    } else {
      this.errorsTarget.innerHTML = ''
    }

    this.emailTarget.value = ''
  }
}
