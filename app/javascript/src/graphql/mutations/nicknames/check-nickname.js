import { graphql } from 'react-relay'

const checkNicknameMutation = graphql`
  mutation checkNicknameMutation($input: CheckNicknameInput!) {
    check_nickname(input: $input) {
      errors {
        field
        messages
      }
    }
  }
`

export default checkNicknameMutation
