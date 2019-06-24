process.env.NODE_ENV = process.env.NODE_ENV || 'development'
const BundleAnalyzerPlugin = require('webpack-bundle-analyzer').BundleAnalyzerPlugin
const environment = require('./environment')

environment.config.merge({
  devServer: {
    stats: 'minimal'
  }
})

environment.plugins.append('BundleAnalyzer', new BundleAnalyzerPlugin({ openAnalyzer: false }))
module.exports = environment.toWebpackConfig()
