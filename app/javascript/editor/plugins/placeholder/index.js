// @flow

import './styles.sass'

import { Decoration, DecorationSet, EditorView } from 'prosemirror-view'
import { Node, Plugin } from 'prosemirror-state'

import { Element } from 'editor/base'
import includes from 'lodash/includes'

export default class Placeholder extends Element {
  name = 'placeholder'

  options = {
    emptyH1Class: 'title-empty',
    H1Class: 'title',
    emptyH2Class: 'subtitle-empty',
    H2Class: 'subtitle',
    emptyBodyClass: 'body-empty',
    emptyH1Text: 'Title',
    emptyH2Text: 'Subtitle',
    emptyBodyText: 'Write your post here...',
    showOnlyWhenEditable: true
  }

  get update() {
    return (view: EditorView) => {
      view.updateState(view.state)
    }
  }

  getDecoration(node: Node, pos: number) {
    let option

    const prefix = node.childCount === 0 ? 'empty' : ''

    switch (node.type.name) {
      case 'heading':
        option = {
          class: this.options[`${prefix}H${node.attrs.level}Class`],
          'data-empty-text': this.options[`${prefix}H${node.attrs.level}Text`]
        }
        break

      case 'paragraph':
        option = {
          class: this.options[`${prefix}BodyClass`],
          'data-empty-text': this.options[`${prefix}BodyText`]
        }
        break

      default:
        break
    }

    return Decoration.node(pos, pos + node.nodeSize, option)
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
              const isSubtitle = secondChild === node && node.attrs.level === 2
              const isEmptyBody = secondChild === node && node.type.name === 'paragraph'

              if (isTitle || (isSubtitle || isEmptyBody)) {
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
