process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const { join } = require('path')
const hypernova = require('hypernova/server')
const { renderReact } = require('../app/javascript/utils/hypernova-nerv.js')
const { environment } = require('@rails/webpacker')
const requireFromUrl = require('require-from-url/sync')
const detect = require('detect-port')

const config = environment.toWebpackConfig()
const devServerUrl = `http://${config.devServer.host}:${config.devServer.port}`

function camelize (text) {
  const separator = '_'
  const words = text.split(separator)
  if (words.length === 0) return text.charAt(0).toUpperCase() + word.slice(1)
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

const detectPort = new Promise((resolve, reject) =>
  detect(config.devServer.port, (err, _port) => {
    if (err) {
      resolve(false)
    }

    if (config.devServer.port === _port) {
      resolve(false)
    } else {
      resolve(true)
    }
  })
)

hypernova({
  devMode: true,
  port: 3030,
  async getComponent (name) {
    const isDevServerRunning = await detectPort
    const serverBundle = require(
      join(config.output.path, 'manifest.json')
    )['server.js']

    if (isDevServerRunning) {
      requireFromUrl(`${devServerUrl}${serverBundle}`)
    } else {
      require(join(config.output.path, '..', serverBundle))
    }

    console.log(`Rendering ${camelize(name)}`)
    return renderReact(camelize(name), eval(camelize(name)))
  }
})
