const { environment, config } = require('@rails/webpacker')

const webpack = require('webpack')
const LodashModuleReplacementPlugin = require('lodash-webpack-plugin')
const nullLoader = require('./loaders/null')
const globImporter = require('node-sass-glob-importer')
const WorkboxPlugin = require('workbox-webpack-plugin')
const { resolve } = require('path')

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

environment.plugins.append(
  'SW',
  new WorkboxPlugin.GenerateSW({
    swDest: resolve(config.public_root_path, 'sw.js'),
    clientsClaim: true,
    exclude: [/\.map$/, /manifest\.json$/],
    importWorkboxFrom: 'cdn',
    skipWaiting: true,
    navigateFallback: process.env.CHUSPACE_URL,
    navigateFallbackBlacklist: [
      // Exclude URLs starting with /_, as they're likely an API call
      new RegExp('^/_'),
      // Exclude any URLs whose last part seems to be a file extension
      // as they're likely a resource and not a SPA route.
      // URLs containing a "?" character won't be blacklisted as they're likely
      // a route with query params (e.g. auth callbacks).
      new RegExp('/[^/?]+\\.[^/]+$')
    ]
  })
)

module.exports = environment
