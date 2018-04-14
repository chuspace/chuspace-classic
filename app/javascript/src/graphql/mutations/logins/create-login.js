import { graphql } from 'react-relay'

const createLoginMutation = graphql`
  mutation createLoginMutation($input: CreateLoginInput!) {
    create_login(input: $input) {
      user {
        id
        name
      }
      errors {
        field
        messages
      }
    }
  }
`

export default createLoginMutation
