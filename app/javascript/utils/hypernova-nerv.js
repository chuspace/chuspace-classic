const { render, hydrate, createElement } = require('nervjs')
const { renderToString, renderToStaticMarkup } = require('nerv-server')
const hypernova = require('hypernova')

const renderReact = (name, component) =>
  hypernova({
    server () {
      return props => {
        const contents = renderToString(createElement(component, props))
        return hypernova.serialize(name, contents, props)
      }
    },

    client () {
      const payloads = hypernova.load(name)

      if (payloads) {
        payloads.forEach(payload => {
          const { node, data } = payload
          const element = createElement(component, data)

          if (hydrate) {
            hydrate(element, node)
          } else {
            render(element, node)
          }
        })
      }

      return component
    }
  })

const renderReactStatic = (name, component) =>
  hypernova({
    server () {
      return props => renderToStaticMarkup(createElement(component, props))
    },

    client () {}
  })

module.exports = {
  renderReact,
  renderReactStatic
}
