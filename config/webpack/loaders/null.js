const { resolve, join } = require('path')
const { config } = require('@rails/webpacker')
const { nodeEnv } = require('@rails/webpacker/package/env')

const packsPath = join(config.source_path, config.source_entry_path)

module.exports =
  nodeEnv === 'production'
    ? {
        test: resolve(`${packsPath}/graphiql`),
        use: 'null-loader'
      }
    : {}
