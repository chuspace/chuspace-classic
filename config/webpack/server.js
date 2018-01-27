const { basename, dirname, join, relative, resolve } = require('path')
const { sync } = require('glob')
const { config } = require('@rails/webpacker')
const extname = require('path-complete-extname')
const ManifestPlugin = require('webpack-manifest-plugin')
const environment = require('./environment')

const publicPath = `/${config.server_packs_path}/`.replace(/([^:]\/)\/+/g, '$1')

environment.plugins.set('Manifest', new ManifestPlugin({ publicPath, writeToFileEmit: true, seed: {} }))

const serverConfig = Object.assign({}, environment.toWebpackConfig())

const getEntryObject = () => {
  const result = {}
  const rootPath = join(config.source_path, config.server_packs_path)
  const paths = sync(join(rootPath, '**/*.js'))

  paths.forEach((path) => {
    const namespace = relative(join(rootPath), dirname(path))
    const name = join(namespace, basename(path, extname(path)))
    result[name] = resolve(path)
  })

  return result
}

serverConfig.entry = getEntryObject()

Object.assign(serverConfig.output, {
  libraryTarget: 'commonjs',
  path: resolve(join('public', config.server_packs_path)),
  publicPath: `/${config.server_packs_path}/`.replace(/([^:]\/)\/+/g, '$1')
})

module.exports = serverConfig
