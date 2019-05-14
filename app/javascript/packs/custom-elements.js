import '@github/details-menu-element'

import { definitionsFromContext } from 'stimulus/webpack-helpers'

const componentsContext = require.context('../../components', true, /\.(js)$/)

componentsContext.keys().forEach(key => componentsContext(key))
