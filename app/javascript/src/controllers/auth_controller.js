// @flow

import { Controller } from 'stimulus'
import Dialog from 'helpers/dialog'

export default class extends Controller {
  static targets = [
    'loginActions',
    'loginForm',
    'registerActions',
    'registerForm'
  ]

  connect () {
    this.loginActionsDialog = new Dialog(this.loginActionsTarget)
    this.loginFormDialog = new Dialog(this.loginFormTarget)

    this.registerActionsDialog = new Dialog(this.registerActionsTarget)
    this.registerFormDialog = new Dialog(this.registerFormTarget)
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
