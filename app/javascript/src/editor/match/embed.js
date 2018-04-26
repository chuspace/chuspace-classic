// @flow
import type { Change, Text } from 'slate'

export default function (currentTextNode: Text, change: Change) {
  const currentLineText = currentTextNode.text

  return change
    .insertInline({
      type: 'html',
      isVoid: true,
      data: { href: currentLineText }
    })
    .removeNodeByKey(currentTextNode.key)
    .collapseToStartOfNextText()
}
