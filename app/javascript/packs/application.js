// Bootstrap app

import 'styles/application'
import 'animate.css'
import '../images/logo.png'
import 'details-element-polyfill'
import '@github/details-menu-element'
import '@github/auto-complete-element'
import 'custom-elements'
import 'helpers/ga.js.erb'

import * as Rails from 'rails-ujs'
import * as Turbolinks from 'turbolinks'

import { Application } from 'stimulus'
import { definitionsFromContext } from 'stimulus/webpack-helpers'
import lazySizes from 'lazysizes'

lazySizes.cfg.lazyClass = 'lazy'
lazySizes.cfg.blurupMode = 'auto'

const application = Application.start()
const controllersContext = require.context('../controllers', true, /\.js$/)
application.load(definitionsFromContext(controllersContext))

Rails.start()
Turbolinks.start()
