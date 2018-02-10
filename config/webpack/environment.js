const { environment } = require('@rails/webpacker')
const incstr = require('incstr')

const createUniqueIdGenerator = () => {
  const index = {}

  const generateNextId = incstr.idGenerator({
    alphabet: 'abcefghijklmnopqrstuvwxyz0123456789'
  })

  return (name) => {
    if (index[name]) return index[name]

    let nextId

    do {
      // Class name cannot start with a number.
      nextId = generateNextId()
    } while (/^[0-9]/.test(nextId))

    index[name] = generateNextId()

    return index[name]
  }
}

const uniqueIdGenerator = createUniqueIdGenerator()

const generateScopedName = (localName, resourcePath) => {
  const componentName = resourcePath.split('/').slice(-2, -1)

  return uniqueIdGenerator(componentName) + '_' + uniqueIdGenerator(localName)
}

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

const cssModulesOptions = {
  modules: true,
  camelCase: true,
  localIdentName: '[name]__[local]___[hash:base64:5]',
  getLocalIdent: (context, localIdentName, localName) => {
    return generateScopedName(localName, context.resourcePath);
  },
}

const cssLoader = environment.loaders
  .get('sass')
  .use.find(el => el.loader === 'css-loader')

cssLoader.options = Object.assign({}, cssLoader.options, cssModulesOptions)

module.exports = environment
