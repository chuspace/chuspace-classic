// @flow

import { Controller } from 'stimulus'
import capitalize from 'lodash/capitalize'

type Error = {
  field: string,
  errors: string
}

export default class Login extends Controller {
  static inputs = ['inputEmail']
  static errors = ['inputEmailError']

  static targets = ['form', 'formSuccess', ...Login.inputs, ...Login.errors]

  toggleSuccess = () => this.formTarget.classList.add('hidden')

  onLoginSuccess (event: window.CustomEvent) {
    const [data] = event.detail

    if (data.errors && data.errors.length > 0) {
      this.resetErrors()
      this.setFormErrors(data.errors)
      return
    }

    this.setSuccessMessage(data.success)
    this.toggleSuccess()

    setTimeout(() => {
      this.reset()
    }, 5000)
  }

  setFormErrors = (errors: $ReadOnlyArray<Error>) =>
    errors.forEach(error => {
      const target = this[`input${capitalize(error.field)}ErrorTarget`]
      target.innerHTML = error.errors
    })

  setSuccessMessage = (message: string) => {
    this.formSuccessTarget.innerHTML = message
  }

  reset = () => {
    this.resetForm()
    this.resetErrors()
    this.setSuccessMessage('')
    this.formTarget.classList.remove('hidden')
  }

  resetForm = () =>
    Login.inputs.forEach(targetKey => {
      const target = this[`${targetKey}Target`]
      target.value = ''
    })

  resetErrors = () =>
    Login.errors.forEach(targetKey => {
      const target = this[`${targetKey}Target`]
      target.innerHTML = ''
    })
}
