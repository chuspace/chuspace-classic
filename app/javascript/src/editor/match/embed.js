// @flow
import type { Change, Text } from 'slate'

import { HTML } from 'editor/constants/inlines'

export default function (currentTextNode: Text, change: Change) {
  const currentLineText = currentTextNode.text
  change
    .insertInline({
      type: HTML,
      isVoid: true,
      data: { href: currentLineText }
    })
    .removeNodeByKey(currentTextNode.key, { normalize: false })
}
