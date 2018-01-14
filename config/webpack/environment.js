const LodashModuleReplacementPlugin = require('lodash-webpack-plugin')
const { environment } = require('@rails/webpacker')

environment.plugins.prepend('LodashModuleReplacement', new LodashModuleReplacementPlugin())

environment.config.merge({
  resolve: {
    alias: {
      'react': 'nervjs',
      'react-dom': 'nervjs',
      'react-dom/server': 'nerv-server'
    }
  }
})

module.exports = environment
