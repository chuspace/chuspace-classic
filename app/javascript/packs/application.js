// Support component names relative to this directory:
require('babel-polyfill')
var Rails = require('rails-ujs')
var componentRequireContext = require.context('src/components', true)
var ReactRailsUJS = require('react_ujs')

require('tachyons/src/tachyons')
require('styles/application')

Rails.start()
ReactRailsUJS.useContext(componentRequireContext)
