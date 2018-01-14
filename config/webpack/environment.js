const LodashModuleReplacementPlugin = require('lodash-webpack-plugin')
const UglifyJsPlugin = require('uglifyjs-webpack-plugin')
const { environment } = require('@rails/webpacker')

environment.plugins.prepend(
  'LodashModuleReplacement',
  new LodashModuleReplacementPlugin()
)

environment.plugins.append(
  'UglifyJs',
  new UglifyJsPlugin({
    cache: true,
    parallel: true,
    sourceMap: true,
    uglifyOptions:{
      ie8: false,
      ecma: 8,
      sourceMap: true,
      mangle: {
        safari10: true
      },
      compress: {
        warnings: false,
        comparisons: false
      },
      output: {
        comments: false,
        ascii_only: true
      }
    }
  })
)

environment.config.merge({
  resolve: {
    alias: {
      react: 'nervjs',
      'react-dom': 'nervjs',
      'react-dom/server': 'nerv-server'
    }
  }
})

module.exports = environment
