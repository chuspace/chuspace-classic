// @flow

import { Controller } from 'stimulus'
import withForm from 'helpers/form'

export default
@withForm
class SshKeys extends Controller {
  static inputs = ['inputTitle', 'inputKey']
  static errors = ['inputTitleError', 'inputKeyError']
}
