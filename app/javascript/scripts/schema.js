#!/usr/bin/env babel-node --optional es7.asyncFunctions
const fs = require('fs')
const path = require('path')
const fetch = require('isomorphic-fetch')

// Util function to fetch schema from server
fetch(`http://${process.env.API_HOST}/graphql/schema`, {
  method: 'GET',
  headers: { 'Content-Type': 'text/plain' }
})
  .then(response => {
    return response.text()
  })
  .then(schema => {
    fs.writeFileSync(
      path.join(__dirname, '../graphql/schema.graphql'),
      `${schema}\n`
    )
  })
