// Bootstrap app

import 'babel-polyfill'
import 'styles/application'

import * as Rails from 'rails-ujs'
import * as Turbolinks from 'turbolinks'

import { Application } from 'stimulus'
import uniq from 'lodash/uniq'

const application = Application.start()
const context = require.context('../../views/components', true, /\.js$/)

context.keys().forEach((key: string) => {
  let modulePath = key.replace('./', '')
  let controller = context(key)

  let pathParts = uniq(modulePath.replace('.js', '').split('/'))
  let name = pathParts.join('.')

  if (typeof controller.default === 'function') {
    application.register(name, controller.default)
  }
})

Rails.start()
Turbolinks.start()
