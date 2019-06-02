// Bootstrap app

import 'styles/application'
import 'animate.css'

import * as Rails from 'rails-ujs'
import * as Turbolinks from 'turbolinks'

import { Application } from 'stimulus'
import { definitionsFromContext } from 'stimulus/webpack-helpers'

const application = Application.start()
const context = require.context('../controllers', true, /\.js$/)

application.load(definitionsFromContext(context))

Rails.start()
Turbolinks.start()
