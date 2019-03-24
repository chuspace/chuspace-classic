// @flow

import { Controller } from 'stimulus'
import withForm from 'helpers/form'

export default
@withForm
class Blogs extends Controller {
  static inputs = ['inputName']
  static errors = ['inputNameError']
}
