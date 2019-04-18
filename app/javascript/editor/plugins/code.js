// @flow

import { Element } from 'editor/utils'
import { Plugin } from 'prosemirror-state'
import { nodeInputRule } from 'editor/commands'

export default class Code extends Element {
  name = 'code'

  get plugins() {
    return [
      new Plugin({
        props: {
          handleKeyDown(view, event) {
            if (event.keyCode === 13) {
              const { state } = view
              const { schema, tr } = state

              if (!state.selection.$cursor) {
                return false
              }

              const { nodeBefore, pos } = state.selection.$from

              if (!nodeBefore || !nodeBefore.isText) {
                return false
              }

              const regex = /^```([a-zA-Z]*)?$/
              const matches = nodeBefore.text.match(regex)

              if (matches) {
                const [, language] = matches

                const { tr } = state

                const from = pos - matches[0].length
                const to = pos
                const text = matches[0]

                if (matches[0]) {
                  const node = schema.nodes.code_block.create({ language })
                  tr.replaceWith(pos - matches[0].length - 1, pos, node)

                  view.dispatch(
                    tr.setMeta(this, { transform: tr, from, to, text })
                  )

                  return true
                }
              }
            }

            return false // We did not handle this
          }
        }
      })
    ]
  }
}
