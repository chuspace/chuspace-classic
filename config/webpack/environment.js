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

environment.plugins.prepend(
  'WebpackProvide',
  new webpack.ProvidePlugin({
    diff_match_patch: 'diff_match_patch',
    DIFF_EQUAL: ['diff_match_patch', 'DIFF_EQUAL'],
    DIFF_INSERT: ['diff_match_patch', 'DIFF_INSERT'],
    DIFF_DELETE: ['diff_match_patch', 'DIFF_DELETE']
  })
)

module.exports = environment
