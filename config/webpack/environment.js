const { environment } = require('@rails/webpacker')

environment.config.merge({
  stats: 'minimal',
  resolve: {
    alias: {
      react: 'nervjs',
      'react-dom/server': 'nerv-server',
      'react-dom': 'nervjs'
    }
  }
})

module.exports = environment
