const { environment } = require('@rails/webpacker')

const webpack = require('webpack')
const LodashModuleReplacementPlugin = require('lodash-webpack-plugin')
const nullLoader = require('./loaders/null')
const globImporter = require('node-sass-glob-importer')

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

environment.loaders.append('null', nullLoader)
const sassLoader = environment.loaders.get('sass').use.find(loader => loader.loader === 'sass-loader')
sassLoader.options.importer = globImporter()

module.exports = environment
