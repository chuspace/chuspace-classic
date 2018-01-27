const { environment } = require('@rails/webpacker')

environment.config.merge({
  resolve: {
    alias: {
      react: 'nervjs',
      'react-dom': 'nervjs',
      'react-dom/server': 'nervserver'
    }
  }
})

module.exports = environment
