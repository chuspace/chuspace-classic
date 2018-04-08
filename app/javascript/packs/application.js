// Support component names relative to this directory:
require('babel-polyfill')
var Rails = require('rails-ujs')
var Turbolinks = require('turbolinks')
var componentRequireContext = require.context('src/components', true)
var ReactRailsUJS = require('react_ujs')

Rails.start()
Turbolinks.start()
ReactRailsUJS.useContext(componentRequireContext)
