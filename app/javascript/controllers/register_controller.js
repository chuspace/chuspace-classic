// @flow

import { Controller } from 'stimulus'
import withForm from 'helpers/form'

export default
@withForm
class Register extends Controller {
  static inputs = ['inputName', 'inputNickname', 'inputEmail']
  static errors = ['inputNameError', 'inputNicknameError', 'inputEmailError']
}
