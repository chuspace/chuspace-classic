/* global Rails */
import 'babel-polyfill'

import React from 'react'
import ReactDOM from 'react-dom'
import GraphiQL from 'graphiql'
import fetch from 'isomorphic-fetch'
import Rails from 'rails-ujs'
import 'graphiql/graphiql.css'

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
