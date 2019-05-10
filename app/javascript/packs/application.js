// Bootstrap app

import 'styles/application'
import 'animate.css'
import '../custom-elements'

import * as Rails from 'rails-ujs'
import * as Turbolinks from 'turbolinks'

import { Application } from 'stimulus'
import { definitionsFromContext } from 'stimulus/webpack-helpers'

const application = Application.start()
const context = require.context('../controllers', true, /\.js$/)
const componentsContext = require.context('../../components', true, /\.(js|sass)$/)

application.load(definitionsFromContext(context))
application.load(definitionsFromContext(componentsContext))

Rails.start()
Turbolinks.start()
