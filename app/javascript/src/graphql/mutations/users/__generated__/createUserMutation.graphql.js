/**
 * @flow
 * @relayHash 19615a6dbc178d7a70eba46c1fdbc747
 */

/* eslint-disable */

'use strict';

/*::
import type { ConcreteRequest } from 'relay-runtime';
export type createUserMutationVariables = {|
  input: {
    clientMutationId?: ?string,
    email?: ?string,
    name: string,
    nickname: string,
  },
|};
export type createUserMutationResponse = {|
  +create_user: ?{|
    +user: ?{|
      +id: string,
      +name: ?string,
    |},
    +errors: ?$ReadOnlyArray<?{|
      +field: ?string,
      +messages: ?$ReadOnlyArray<?string>,
    |}>,
  |},
|};
*/


/*
mutation createUserMutation(
  $input: CreateUserInput!
) {
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
*/

const node/*: ConcreteRequest*/ = (function(){
var v0 = [
  {
    "kind": "LocalArgument",
    "name": "input",
    "type": "CreateUserInput!",
    "defaultValue": null
  }
],
v1 = [
  {
    "kind": "LinkedField",
    "alias": null,
    "name": "create_user",
    "storageKey": null,
    "args": [
      {
        "kind": "Variable",
        "name": "input",
        "variableName": "input",
        "type": "CreateUserInput!"
      }
    ],
    "concreteType": "CreateUserPayload",
    "plural": false,
    "selections": [
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "user",
        "storageKey": null,
        "args": null,
        "concreteType": "User",
        "plural": false,
        "selections": [
          {
            "kind": "ScalarField",
            "alias": null,
            "name": "id",
            "args": null,
            "storageKey": null
          },
          {
            "kind": "ScalarField",
            "alias": null,
            "name": "name",
            "args": null,
            "storageKey": null
          }
        ]
      },
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "errors",
        "storageKey": null,
        "args": null,
        "concreteType": "ValidationError",
        "plural": true,
        "selections": [
          {
            "kind": "ScalarField",
            "alias": null,
            "name": "field",
            "args": null,
            "storageKey": null
          },
          {
            "kind": "ScalarField",
            "alias": null,
            "name": "messages",
            "args": null,
            "storageKey": null
          }
        ]
      }
    ]
  }
];
return {
  "kind": "Request",
  "operationKind": "mutation",
  "name": "createUserMutation",
  "id": null,
  "text": "mutation createUserMutation(\n  $input: CreateUserInput!\n) {\n  create_user(input: $input) {\n    user {\n      id\n      name\n    }\n    errors {\n      field\n      messages\n    }\n  }\n}\n",
  "metadata": {},
  "fragment": {
    "kind": "Fragment",
    "name": "createUserMutation",
    "type": "Mutation",
    "metadata": null,
    "argumentDefinitions": v0,
    "selections": v1
  },
  "operation": {
    "kind": "Operation",
    "name": "createUserMutation",
    "argumentDefinitions": v0,
    "selections": v1
  }
};
})();
(node/*: any*/).hash = '4aecca48335d1df1d132d4c2c887c4ff';
module.exports = node;
