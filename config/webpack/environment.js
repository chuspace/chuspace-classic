const { environment } = require('@rails/webpacker')
const webpack = require('webpack')
const LodashModuleReplacementPlugin = require('lodash-webpack-plugin')
const nullLoader = require('./loaders/null')
const mjsLoader = require('./loaders/mjs')

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
environment.loaders.append('mjs', mjsLoader)

const nodeModulesLoader = environment.loaders.get('nodeModules').use[0]
nodeModulesLoader.options.plugins = ['@babel/plugin-syntax-dynamic-import']

module.exports = environment
