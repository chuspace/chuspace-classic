const { environment } = require('@rails/webpacker')
const webpack = require('webpack')

environment.config.merge({
  stats: 'minimal'
})

environment.plugins.append('IgnoreFlow', new webpack.IgnorePlugin(/\.flow$/))

module.exports = environment
