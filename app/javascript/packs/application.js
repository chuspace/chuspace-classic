// Bootstrap app

import '@babel/polyfill'
import 'styles/application'

import * as Rails from 'rails-ujs'
import * as Turbolinks from 'turbolinks'

import { Application } from 'stimulus'
import { definitionsFromContext } from 'stimulus/webpack-helpers'

const application = Application.start()
const context = require.context('../src/controllers', true, /\.js$/)
application.load(definitionsFromContext(context))

Rails.start()
Turbolinks.start()
