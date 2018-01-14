process.env.NODE_ENV = 'development'

const { join } = require('path')
const hypernova = require('hypernova/server')
const { renderReact } = require('../app/javascript/utils/hypernova-nerv.js')
const { environment } = require('@rails/webpacker')

const config = environment.toWebpackConfig()

function camelize (text) {
  const separator = '_'
  const words = text.split(separator)
  if (words.length === 0) return text.charAt(0).toUpperCase() + words.slice(1)
  let result = ''
  let i = 0

  while (i < words.length) {
    const word = words[i]
    const capitalizedWord = word.charAt(0).toUpperCase() + word.slice(1)
    result += capitalizedWord
    i += 1
  }

  return result
}

hypernova({
  devMode: true,
  port: 3030,
  bodyParser: {
    limit: 1024 * 100000
  },
  async getComponent (name) {
    const manifest = require(join(config.output.path, 'manifest.json'))
    const bundle = require(join(config.output.path, '..', manifest[`${name}.js`])).default

    return renderReact(camelize(name), bundle)
  }
})
