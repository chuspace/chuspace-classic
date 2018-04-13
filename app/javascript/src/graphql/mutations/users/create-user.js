import { graphql } from 'react-relay'

const createUserMutation = graphql`
  mutation createUserMutation($input: CreateUserInput!) {
    create_user(input: $input) {
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

export default createUserMutation
