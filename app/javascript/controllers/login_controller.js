// @flow

import { Controller } from 'stimulus'
import withForm from 'helpers/form'

export default
@withForm
class Login extends Controller {
  static inputs = ['inputEmail']
  static errors = ['inputEmailError']
}
