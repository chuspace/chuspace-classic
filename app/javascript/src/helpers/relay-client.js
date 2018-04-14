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

const source = new RecordSource()
const store = new Store(source)
const environment = new Environment({ network, store })

export default {
  environment,
  fetchQuery: fetchQuery.bind(undefined, environment),
  commitMutation: commitMutation.bind(undefined, environment),
  commitLocalUpdate: commitLocalUpdate.bind(undefined, environment)
}
