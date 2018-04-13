const { environment } = require('@rails/webpacker')
const webpack = require('webpack')
const LodashModuleReplacementPlugin = require('lodash-webpack-plugin')

environment.config.merge({
  stats: 'minimal'
})

environment.plugins.append('IgnoreFlow', new webpack.IgnorePlugin(/\.flow$/))
environment.plugins.append(
  'Lodash',
  new LodashModuleReplacementPlugin({
    collections: true,
    paths: true,
    shorthands: true
  })
)

module.exports = environment
