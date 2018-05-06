// @flow
import type { Change, Text } from 'slate'

import INLINES from 'markup-it/lib/constants/inlines'

export default function (currentTextNode: Text, change: Change) {
  const currentLineText = currentTextNode.text
  change
    .insertInline({
      type: INLINES.HTML,
      isVoid: true,
      data: { html: currentLineText }
    })
    .removeNodeByKey(currentTextNode.key)
    .collapseToEnd()
}
