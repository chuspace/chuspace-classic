const { environment } = require('@rails/webpacker')
const webpack = require('webpack')
const LodashModuleReplacementPlugin = require('lodash-webpack-plugin')

environment.plugins.append('IgnoreFlow', new webpack.IgnorePlugin(/\.flow$/))
environment.plugins.append(
  'Lodash',
  new LodashModuleReplacementPlugin({
    collections: true,
    paths: true,
    shorthands: true
  })
)

const nodeModulesLoader = environment.loaders.get('nodeModules').use[0]
nodeModulesLoader.options.plugins = ['@babel/plugin-syntax-dynamic-import']

module.exports = environment
