// @flow

import { Node as ProsemirrorNode, Schema } from 'prosemirror-model'

import { EditorView } from 'prosemirror-view'

export type BaseViewPropType = {
  node: ProsemirrorNode,
  view: EditorView,
  getPos: () => number,
  options: any
}

export default class BaseView {
  options: {}
  dom: Element
  view: EditorView
  schema: Schema
  isSelected: boolean
  getPos: () => number
  node: ProsemirrorNode
  containerNode: HTMLElement

  constructor(props: BaseViewPropType, render: boolean = true) {
    this.view = props.view
    this.schema = props.view.state.schema
    this.getPos = props.getPos
    this.node = props.node
    this.options = props.options
    this.isSelected = false
    this.containerNode = props.node.type.spec.inline ? document.createElement('span') : document.createElement('div')

    if (render) this.renderElement()
  }

  renderElement = () => console.error('Must override')

  update = (updateNode: ProsemirrorNode) => {
    if (updateNode.type !== this.node.type) return false
    this.node = updateNode
    this.renderElement()
    return true
  }

  selectNode = () => {
    console.log(this.view.editable)
    if (this.view.editable) {
      this.isSelected = true
      this.renderElement()
    }
  }

  deselectNode = () => {
    if (this.view.editable) {
      this.isSelected = false
      this.renderElement()
    }
  }

  stopEvent = (evt: Event) =>
    evt.type === 'keypress' ||
    evt.type === 'input' ||
    evt.type === 'keydown' ||
    evt.type === 'keyup' ||
    evt.type === 'paste'

  ignoreMutation = () => true

  destroy = () => {
    this.containerNode.remove()
  }
}
