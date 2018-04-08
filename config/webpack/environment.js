const { environment } = require('@rails/webpacker')

environment.config.merge({
  stats: 'minimal'
})

module.exports = environment
