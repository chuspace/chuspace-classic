// @flow

import type { Change, Editor } from 'slate-react'
import {
  HEADING_1,
  HEADING_2,
  HEADING_3,
  HEADING_4,
  HEADING_5,
  HEADING_6,
  PARAGRAPH
} from 'editor/constants/blocks'

import { KEY_BACKSPACE } from 'editor/constants/keys'
import commonNode from 'editor/renderers/commonNode'
import { haveBlocks } from 'editor/utils/have'
import isEmpty from 'lodash/isEmpty'
import isHotkey from 'is-hotkey'
import nodeAttrs from 'editor/attributes/node'
import type { nodeProps } from 'editor/types'

const applyChange = (change, type) => {
  const isActive = haveBlocks(change, type)
  change.setBlocks(isActive ? PARAGRAPH : type)
  return true
}

const plugin = (type, tagName, hotkey) => {
  return {
    renderNode: (props: nodeProps) => {
      if (props.node.type === type) return commonNode(tagName, nodeAttrs)(props)
    },

    onKeyDown: (e: any, change: Change, editor: Editor) => {
      if (editor.props.name === 'title') {
        if (e.key === 'Enter') {
          e.preventDefault()
          return false
        }
      }

      const { value } = change
      const { blocks, selection } = value
      const getCurrentblock = blocks.get(0)

      if (
        e.key === KEY_BACKSPACE &&
        getCurrentblock.type === type &&
        (isEmpty(getCurrentblock.text) || selection.focusOffset === 0)
      ) {
        return change.setBlocks(PARAGRAPH)
      }

      if (e.key === 'Enter') {
        if (getCurrentblock.type === type) {
          return change.splitBlock().setBlocks(PARAGRAPH)
        }
      } else if (isHotkey(hotkey, e)) {
        e.preventDefault()
        change.call(applyChange, type)
      }
    }
  }
}

export const HeaderOnePlugin = (type: string = HEADING_1) =>
  plugin(type, 'h1', 'ctrl+opt+1')
export const HeaderTwoPlugin = (type: string = HEADING_2) =>
  plugin(type, 'h2', 'ctrl+opt+2')
export const HeaderThreePlugin = (type: string = HEADING_3) =>
  plugin(type, 'h3', 'ctrl+opt+3')
export const HeaderFourPlugin = (type: string = HEADING_4) =>
  plugin(type, 'h4', 'ctrl+opt+4')
export const HeaderFivePlugin = (type: string = HEADING_5) =>
  plugin(type, 'h5', 'ctrl+opt+5')
export const HeaderSixPlugin = (type: string = HEADING_6) =>
  plugin(type, 'h6', 'ctrl+opt+6')
