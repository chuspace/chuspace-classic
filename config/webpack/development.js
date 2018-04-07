process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const environment = require('./environment')

environment.config.merge({
  devServer: {
    stats: 'minimal'
  }
})

module.exports = environment.toWebpackConfig()
