// Support component names relative to this directory:

require('babel-polyfill')
var Rails = require('rails-ujs')
var componentRequireContext = require.context('src/components', true)
var ReactRailsUJS = require('react_ujs')
var Turbolinks = require('turbolinks')

require('tachyons/src/tachyons')
require('emoji-mart/css/emoji-mart.css')
require('styles/global')
require('styles/application')

Rails.start()
Turbolinks.start()
ReactRailsUJS.useContext(componentRequireContext)
