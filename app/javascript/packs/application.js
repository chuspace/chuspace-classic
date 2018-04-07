// Support component names relative to this directory:
require('babel-polyfill')
var componentRequireContext = require.context('src/pages', true)
var ReactRailsUJS = require('react_ujs')
ReactRailsUJS.useContext(componentRequireContext)
