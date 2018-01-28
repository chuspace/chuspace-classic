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

const cssModulesOptions = {
  modules: true,
  localIdentName: '[name]__[local]___[hash:base64:5]'
}

const cssLoader = environment.loaders.get('sass').use.find(el => el.loader === 'css-loader')

cssLoader.options = Object.assign({}, cssLoader.options, cssModulesOptions)

module.exports = environment
