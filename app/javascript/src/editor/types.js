// @flow
import * as React from 'react'

import type { Node } from 'slate'

export type nodeProps = {
  attributes: Object,
  children: React.Element<*>,
  node: Node
}
