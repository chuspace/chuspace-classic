// @flow
import type { Change, Text } from 'slate'

import { Range } from 'slate'

export default function (
  type: string,
  currentTextNode: Text,
  matched: any,
  change: Change
) {
  const matchedLength = matched[0].length
  const reg = matched[1] === ':' ? /:/ : matched[1]
  const code = matched[0].replace(new RegExp(reg, 'g'), '')

  return change
    .deleteAtRange(
      Range.create({
        anchorKey: currentTextNode.key,
        focusKey: currentTextNode.key,
        anchorOffset: matched.index,
        focusOffset: matched.index + matchedLength
      })
    )
    .insertInline({
      type,
      isVoid: true,
      data: { code }
    })
    .collapseToStartOfNextText()
}
