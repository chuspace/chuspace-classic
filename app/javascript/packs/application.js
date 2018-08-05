// Support component names relative to this directory:

import { Application } from 'stimulus'
import { definitionsFromContext } from 'stimulus/webpack-helpers'

require('babel-polyfill')
var Rails = require('rails-ujs')
var Turbolinks = require('turbolinks')

require('styles/global')
require('styles/application')

const application = Application.start()
//const context = require.context('../src/controllers', true, /\.js$/)
application.load(definitionsFromContext(context))

Rails.start()
Turbolinks.start()
