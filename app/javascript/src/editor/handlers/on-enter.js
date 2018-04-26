// @flow

import type { Change } from 'slate'
import EditBlockquote from 'slate-edit-blockquote'
import EditList from 'slate-edit-list'
import matchEmbed from 'editor/match/embed'

export default function onEnter (options: any, change: Change) {
  const { value } = change
  const { blocks, texts, selection } = value
  const getCurrentblock = blocks.get(0)
  const currentTextNode = texts.get(0)
  const currentLineText = currentTextNode.text
  const { isSelectionInList } = EditList(options.listOption).utils
  const { isSelectionInBlockquote } = EditBlockquote(
    options.blockquoteOption
  ).utils

  console.log(getCurrentblock.type)
  return matchEmbed(currentTextNode, change)

  if (
    getCurrentblock.type === options.blocks.CODE_LINE ||
    getCurrentblock.type === options.blocks.CODE ||
    getCurrentblock.type === options.blocks.CODE ||
    isSelectionInList(value) ||
    isSelectionInBlockquote(value) ||
    currentLineText.length > selection.focusOffset
  ) {

  }

  return change.insertBlock(options.blocks.PARAGRAPH)
}
