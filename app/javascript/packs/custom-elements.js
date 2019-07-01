// Bootstrap custom elements

import '@github/details-menu-element'

const componentsContext = require.context('../../components', true, /\.(js)$/)
componentsContext.keys().forEach(key => componentsContext(key))
