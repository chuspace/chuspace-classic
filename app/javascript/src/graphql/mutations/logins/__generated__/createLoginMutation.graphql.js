/**
 * @flow
 * @relayHash 18a627e054df58a92b79400d6370926d
 */

/* eslint-disable */

'use strict';

/*::
import type { ConcreteRequest } from 'relay-runtime';
export type createLoginMutationVariables = {|
  input: {
    clientMutationId?: ?string,
    email?: ?string,
  },
|};
export type createLoginMutationResponse = {|
  +create_login: ?{|
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
mutation createLoginMutation(
  $input: CreateLoginInput!
) {
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
*/

const node/*: ConcreteRequest*/ = (function(){
var v0 = [
  {
    "kind": "LocalArgument",
    "name": "input",
    "type": "CreateLoginInput!",
    "defaultValue": null
  }
],
v1 = [
  {
    "kind": "LinkedField",
    "alias": null,
    "name": "create_login",
    "storageKey": null,
    "args": [
      {
        "kind": "Variable",
        "name": "input",
        "variableName": "input",
        "type": "CreateLoginInput!"
      }
    ],
    "concreteType": "CreateLoginPayload",
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
  "name": "createLoginMutation",
  "id": null,
  "text": "mutation createLoginMutation(\n  $input: CreateLoginInput!\n) {\n  create_login(input: $input) {\n    user {\n      id\n      name\n    }\n    errors {\n      field\n      messages\n    }\n  }\n}\n",
  "metadata": {},
  "fragment": {
    "kind": "Fragment",
    "name": "createLoginMutation",
    "type": "Mutation",
    "metadata": null,
    "argumentDefinitions": v0,
    "selections": v1
  },
  "operation": {
    "kind": "Operation",
    "name": "createLoginMutation",
    "argumentDefinitions": v0,
    "selections": v1
  }
};
})();
(node/*: any*/).hash = '30c456347f2fa6edefcd0b93bda2ab86';
module.exports = node;
