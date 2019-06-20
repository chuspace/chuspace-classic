// @flow

/* global FileReader */

/** @jsx h */

import * as Rails from 'rails-ujs'

import { EditorState, Plugin, PluginKey, Transaction } from 'prosemirror-state'

import { ImageComponent } from 'editor/components'
import { Node } from 'editor/base'
import { Node as PMNode } from 'prosemirror-model'
import { h } from 'preact'
import { nodeInputRule } from 'editor/commands'

const IMAGE_INPUT_REGEX = /!\[(.+|:?)\]\((\S+)(?:(?:\s+)["'](\S+)["'])?\)/
export default class Image extends Node {
  name = 'image'

  get schema() {
    return {
      attrs: {
        src: {},
        alt: {
          default: null
        },
        title: {
          default: null
        },
        width: { default: 750 },
        align: { default: 'center' }
      },
      inline: true,
      group: 'inline',
      draggable: false,
      parseDOM: [
        {
          tag: 'img[src]',
          getAttrs: (dom: PMNode) => ({
            src: dom.getAttribute('src'),
            title: dom.getAttribute('title'),
            alt: dom.getAttribute('alt'),
            width: dom.getAttribute('width'),
            align: dom.getAttribute('align')
          })
        }
      ],
      toDOM: (node: PMNode) => ['img', node.attrs],
      toStatic: (node: PMNode, options: any, isSelected: boolean, isEditable: boolean, handleAltChange: () => void) => {
        return (
          <ImageComponent
            key={node.currIndex}
            attrs={node.attrs}
            options={options}
            isSelected={isSelected}
            isEditable={isEditable}
            handleAltChange={handleAltChange}
          />
        )
      }
    }
  }

  inputRules({ type }: PMNode) {
    return [
      nodeInputRule(IMAGE_INPUT_REGEX, type, match => {
        const [, alt, src, title] = match
        return {
          src,
          alt,
          title
        }
      })
    ]
  }

  commands({ type }: PMNode) {
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
        key: new PluginKey('image'),
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
                const formData = new FormData()
                formData.append('image', image)

                Rails.ajax({
                  type: 'POST',
                  url: '/images',
                  data: formData,
                  success: data => {
                    const node = schema.nodes.image.create({
                      src: data.url
                    })

                    const transaction = view.state.tr.insert(coordinates.pos, node)
                    view.dispatch(transaction)
                  },
                  error: data => {
                    return false
                  }
                })
              })
            }
          }
        }
      })
    ]
  }
}
