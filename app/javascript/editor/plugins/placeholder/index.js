// @flow

import './styles.sass'

import { Decoration, DecorationSet, EditorView } from 'prosemirror-view'
import { Node, Plugin } from 'prosemirror-state'

import { Element } from 'editor/base'
import includes from 'lodash/includes'

export default class Placeholder extends Element {
  name = 'placeholder'

  options = {
    h1Class: 'title',
    h2Class: 'excerpt',
    paragraphClass: 'body',
    h1Text: 'Title',
    h2Text: 'Subtitle',
    paragraphText: 'Write your post here...'
  }

  get update() {
    return (view: EditorView) => {
      view.updateState(view.state)
    }
  }

  getDecoration(node: Node, pos: number) {
    let option
    let className
    let text

    const suffix = node.childCount === 0 ? '-empty' : ''
    const typePrefix = node.attrs.level ? `h${node.attrs.level}` : 'paragraph'

    className = this.options[`${typePrefix}Class`] + suffix
    text = this.options[`${typePrefix}Text`]

    return Decoration.node(pos, pos + node.nodeSize, {
      class: className,
      'data-empty-text': text
    })
  }

  get plugins() {
    return [
      new Plugin({
        props: {
          decorations: ({ doc, plugins }) => {
            const editablePlugin = plugins.find(plugin => plugin.key.startsWith('editable$'))
            const editable = editablePlugin.props.editable()

            if (!editable) {
              return false
            }

            const decorations = []

            doc.descendants((node, pos) => {
              const [firstChild, secondChild] = doc.content.content
              const hasPlaceholder = includes(['heading', 'paragraph'], node.type.name)

              if (!hasPlaceholder) {
                return
              }

              const isTitle = firstChild === node && node.attrs.level === 1
              const isExcerpt = secondChild === node && node.attrs.level === 2
              const isEmptyBody = secondChild === node && node.type.name === 'paragraph'

              if (isTitle || (isExcerpt || isEmptyBody)) {
                decorations.push(this.getDecoration(node, pos))
              }
            })

            return DecorationSet.create(doc, decorations)
          }
        }
      })
    ]
  }
}
