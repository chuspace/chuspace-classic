process.env.NODE_ENV = process.env.NODE_ENV || 'production'

const environment = require('./environment')
const WorkboxWebpackPlugin = require('workbox-webpack-plugin')
const { join, resolve } = require('path')
const { config } = require('@rails/webpacker')

environment.plugins.append(
  'Workbox',
  new WorkboxWebpackPlugin.GenerateSW({
    cacheId: 'chuspace-v1',
    clientsClaim: true,
    skipWaiting: true,
    navigateFallback: '/offline.html',
    swDest: resolve(config.public_root_path, 'sw.js')
  })
)

module.exports = environment.toWebpackConfig()
