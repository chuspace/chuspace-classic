// @flow

import { Controller } from 'stimulus'
import Dialog from 'helpers/dialog'

export default class extends Controller {
  static targets = [
    'loginActionsCard',
    'loginFormCard',
    'loginForm',
    'loginFormEmail',
    'loginFormErrors',
    'loginFormSuccess',
    'registerActionsCard',
    'registerFormCard',
    'registerForm',
    'registerFormName',
    'registerFormNickname',
    'registerFormEmail',
    'registerFormErrors',
    'registerFormSuccess'
  ]

  connect () {
    this.loginActionsDialog = new Dialog(this.loginActionsCardTarget)
    this.loginFormDialog = new Dialog(this.loginFormCardTarget)

    this.registerActionsDialog = new Dialog(this.registerActionsTarget)
    this.registerFormDialog = new Dialog(this.registerFormTarget)
  }

  onLoginSuccess (event: window.CustomEvent) {
    let [data] = event.detail

    if (data.errors) {
      this.loginFormErrorsTarget.innerHTML = data.errors
      return
    }

    if (data.success) {
      this.loginFormSuccessTarget.innerHTML = data.success
      this.loginFormTarget.classList.add('hidden')
    }

    this.loginFormErrorsTarget.innerHTML = ''
    this.loginFormEmailTarget.value = ''
    setTimeout(() => this._hideAll(), 1000)
  }

  showRegisterActions (e: Event) {
    e.preventDefault()
    this._hideAll()
    this.registerActionsDialog.show()
  }

  showRegisterForm (e: Event) {
    e.preventDefault()
    this._hideAll()
    this.registerFormDialog.show()
  }

  showLoginActions (e: Event) {
    e.preventDefault()
    this._hideAll()
    this.loginActionsDialog.show()
  }

  showLoginForm (e: Event) {
    e.preventDefault()
    this._hideAll()
    this.loginFormDialog.show()
  }

  _hideAll () {
    this.loginFormDialog.hide()
    this.loginActionsDialog.hide()
    this.registerFormDialog.hide()
    this.registerActionsDialog.hide()
  }
}
