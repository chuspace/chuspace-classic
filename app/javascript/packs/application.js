// Bootstrap app

import 'styles/application'
import 'animate.css'
import 'turbolinks'
import '@github/details-menu-element'
import 'custom-elements'

import * as Rails from 'rails-ujs'

import { Application } from 'stimulus'
import { definitionsFromContext } from 'stimulus/webpack-helpers'

const application = Application.start()
const controllersContext = require.context('../controllers', true, /\.js$/)
application.load(definitionsFromContext(controllersContext))

Rails.start()
Turbolinks.start()
