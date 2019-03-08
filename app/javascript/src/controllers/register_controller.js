// @flow

import { Controller } from 'stimulus'
import capitalize from 'lodash/capitalize'

type Error = {
  field: string,
  errors: string
}

export default class Register extends Controller {
  static inputs = ['inputName', 'inputNickname', 'inputEmail']
  static errors = [
    'inputNameError',
    'inputNicknameError',
    'inputEmailError'
  ]

  static targets = [
    'form',
    'formSuccess',
    ...Register.inputs,
    ...Register.errors
  ]

  toggleSuccess = () => this.formTarget.classList.add('hidden')

  onRegisterSuccess (event: window.CustomEvent) {
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
    Register.inputs.forEach(targetKey => {
      const target = this[`${targetKey}Target`]
      target.value = ''
    })

  resetErrors = () =>
    Register.errors.forEach(targetKey => {
      const target = this[`${targetKey}Target`]
      target.innerHTML = ''
    })
}
