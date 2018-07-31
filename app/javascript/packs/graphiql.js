import 'babel-polyfill'
import 'graphiql/graphiql.css'

import GraphiQL from 'graphiql'
import Rails from 'rails-ujs'
import React from 'react'
import ReactDOM from 'react-dom'
import fetch from 'isomorphic-fetch'

Rails.start()

const graphQLFetcher = async graphQLParams => {
  graphQLParams.operationName = graphQLParams.operationName || 'graphiql'

  const response = await fetch(window.location.origin + '/graphql', {
    method: 'post',
    credentials: 'same-origin',
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-token': Rails.csrfToken()
    },
    body: JSON.stringify(graphQLParams)
  })

  const data = await response.json()
  return data
}

document.addEventListener('DOMContentLoaded', () =>
  ReactDOM.render(
    <GraphiQL fetcher={graphQLFetcher} />,
    document.getElementById('graphiql')
  )
)
