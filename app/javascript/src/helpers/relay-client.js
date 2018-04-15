import {
  Environment,
  RecordSource,
  Store,
  fetchQuery,
  commitMutation,
  commitLocalUpdate
} from 'relay-runtime'

import {
  RelayNetworkLayer,
  urlMiddleware,
  batchMiddleware,
  loggerMiddleware,
  errorMiddleware,
  perfMiddleware,
  retryMiddleware,
  cacheMiddleware
} from 'react-relay-network-modern'

import ActionCable from 'actioncable'
import Rails from 'rails-ujs'

import createSubscriptionHandler from 'graphql-ruby-client/subscriptions/createHandler'

const __DEV__ = process.env.NODE_ENV === 'development'
const cable = ActionCable.createConsumer()

let relayEnvironment = null

const fetchOperation = urlMiddleware({
  url: req => Promise.resolve('/graphql'),
  credentials: 'same-origin',
  headers: {
    'X-CSRF-Token': Rails.csrfToken()
  }
})

const subscriptionHandler = createSubscriptionHandler({
  cable,
  fetchOperation
})

const options = {
  subscribeFn: subscriptionHandler
}

const network = new RelayNetworkLayer(
  [
    cacheMiddleware({
      size: 100,
      ttl: 900000
    }),
    fetchOperation,
    batchMiddleware({
      batchUrl: requestMap => Promise.resolve('/graphql/batch'),
      batchTimeout: 10
    }),
    __DEV__ ? loggerMiddleware() : null,
    __DEV__ ? errorMiddleware() : null,
    __DEV__ ? perfMiddleware() : null,
    retryMiddleware({
      fetchTimeout: 15000,
      retryDelays: attempt => Math.pow(2, attempt + 4) * 100,
      forceRetry: (cb, delay) => {
        window.forceRelayRetry = cb
        console.log(
          'call `forceRelayRetry()` for immediately retry! Or wait ' +
            delay +
            ' ms.'
        )
      },
      statusCodes: [500, 503, 504]
    })
  ],
  options
)

export const initEnvironment = ({ records = {} } = {}) => {
  const source = new RecordSource(records)
  const store = new Store(source)

  if (!process.browser) {
    return new Environment({
      network,
      store
    })
  }

  if (!relayEnvironment) {
    relayEnvironment = new Environment({
      network,
      store
    })
  }

  return relayEnvironment
}

const environment = initEnvironment()

export default {
  initEnvironment: initEnvironment,
  environment,
  fetchQuery: fetchQuery.bind(undefined, environment),
  commitMutation: commitMutation.bind(undefined, environment),
  commitLocalUpdate: commitLocalUpdate.bind(undefined, environment)
}
