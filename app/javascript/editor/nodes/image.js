// @flow

/* global FileReader */

import { EditorState, Plugin, Transaction } from 'prosemirror-state'

import { Node } from 'editor/utils'
import type { NodeType } from 'editor/utils'
import { Node as ProsemirrorNode } from 'prosemirror-model'

export default class Image extends Node {
  name = 'image'

  get schema() {
    return {
      inline: true,
      attrs: {
        src: {},
        alt: {
          default: null
        },
        title: {
          default: null
        }
      },
      group: 'inline',
      draggable: true,
      parseDOM: [
        {
          tag: 'img[src]',
          getAttrs: (dom: ProsemirrorNode) => ({
            src: dom.getAttribute('src'),
            title: dom.getAttribute('title'),
            alt: dom.getAttribute('alt')
          })
        }
      ],
      toDOM: (node: ProsemirrorNode) => ['img', node.attrs]
    }
  }

  commands({ type }: NodeType) {
    return (attrs: {}) => (state: EditorState, dispatch: Transaction) => {
      const { selection } = state
      const position = selection.$cursor ? selection.$cursor.pos : selection.$to.pos
      const node = type.create(attrs)
      const transaction = state.tr.insert(position, node)
      dispatch(transaction)
    }
  }

  get plugins() {
    return [
      new Plugin({
        props: {
          handleDOMEvents: {
            drop(view, event) {
              const hasFiles = event.dataTransfer && event.dataTransfer.files && event.dataTransfer.files.length

              if (!hasFiles) {
                return
              }

              const images = Array.from(event.dataTransfer.files).filter(file => /image/i.test(file.type))

              if (images.length === 0) {
                return
              }

              event.preventDefault()

              const { schema } = view.state
              const coordinates = view.posAtCoords({
                left: event.clientX,
                top: event.clientY
              })

              images.forEach(image => {
                const reader = new FileReader()

                reader.onload = readerEvent => {
                  const node = schema.nodes.image.create({
                    src: readerEvent.target.result
                  })
                  const transaction = view.state.tr.insert(coordinates.pos, node)
                  view.dispatch(transaction)
                }
                reader.readAsDataURL(image)
              })
            }
          }
        }
      })
    ]
  }
}
