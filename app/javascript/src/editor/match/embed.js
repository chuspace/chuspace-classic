// @flow
import type { Change, Text } from 'slate'

export default function (currentTextNode: Text, matched: any, change: Change) {
  const currentLineText = currentTextNode.text
  return change
    .insertInline({
      type: 'link',
      isVoid: true,
      data: { href: currentLineText, class: 'embedly-card' }
    })
    .removeNodeByKey(currentTextNode.key, { normalize: false })
}
