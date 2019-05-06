// @flow

import { Plugin, Selection } from 'prosemirror-state'

import { Element } from '@chuspace/editor-base'
import { nodeInputRule } from '@chuspace/editor-commands'

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
                  const selection = Selection.near(state.doc.resolve(from), to)

                  tr.replaceWith(pos - matches[0].length - 1, pos, node)
                    .setMeta(this, {
                      transform: tr,
                      from,
                      to,
                      text
                    })
                    .setSelection(selection)
                    .scrollIntoView()

                  view.dispatch(tr)

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
