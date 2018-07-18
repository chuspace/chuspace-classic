// @flow

import { NodeSelection } from 'prosemirror-state'
import React from 'react'
import ReactDOM from 'react-dom'
import ReactViewWrapper from './react-view-wrapper'

export default class ReactView {
  decorations: any
  block: any
  node: any
  view: any
  getPos: any
  reactElement: ?ReactViewWrapper
  dom: HTMLElement
  renderComponent: any
  isReadOnly: boolean

  constructor (
    node: any,
    view: any,
    getPos: any,
    decorations: any,
    isReadOnly: boolean
  ) {
    const nodeSpec = node.type.spec
    this.decorations = decorations
    this.block = !nodeSpec.inline
    this.node = node
    this.view = view
    this.getPos = getPos
    this.isReadOnly = isReadOnly
    this.renderComponent = !isReadOnly ? nodeSpec.toEditable : nodeSpec.toStatic

    const domChild = this.block
      ? document.createElement('div')
      : document.createElement('span')
    this.renderElement(domChild)
    this.dom = domChild
  }

  updateAttrs = (nodeAttrs: any) => {
    const start = this.getPos()
    if (start !== undefined) {
      const oldNodeAttrs = this.node.attrs
      const transaction = this.view.state.tr.setNodeMarkup(start, null, {
        ...oldNodeAttrs,
        ...nodeAttrs
      })
      this.view.dispatch(transaction)
    }
  }

  updateContent = (content: any) => {
    const start = this.getPos()
    const nodeType = this.node.type
    const transaction = this.view.state.tr.setNodeMarkup(start, nodeType, {
      content
    })
    this.view.dispatch(transaction)
  }

  // Needs to be override by child classes
  renderElement = (domChild: HTMLElement) =>
    ReactDOM.render(
      <ReactViewWrapper
        ref={elem => {
          this.reactElement = elem
        }}
        node={this.node}
        view={this.view}
        decorations={this.decorations}
        forceSelection={this.forceSelection}
        updateAttrs={this.updateAttrs}
        updateContent={this.updateContent}
        changeNode={this.changeNode}
        renderComponent={this.renderComponent}
        getPos={this.getPos}
        isReadOnly={this.isReadOnly}
      />,
      domChild
    )

  update = (node: any, decorations: any) => {
    if (node.type !== this.node.type) return false
    if (node === this.node && this.decorations === decorations) {
      return true
    }
    this.node = node
    this.decorations = decorations
    this.renderElement(this.dom)
    return true
  }

  changeNode = (nodeType: any, attrs: any, content: any) => {
    const newNode = nodeType.create(attrs, content)
    const start = this.getPos()
    const end = start + this.node.nodeSize
    const transaction = this.view.state.tr.replaceWith(start, end, newNode)
    this.view.dispatch(transaction)
  }

  forceSelection = () => {
    const pos = this.getPos()
    const sel = NodeSelection.create(this.view.state.doc, pos)
    const transaction = this.view.state.tr.setSelection(sel)
    // this.reactElement.focusAndSelect();
    this.view.dispatch(transaction)
  }

  selectNode = () => this.reactElement && this.reactElement.focusAndSelect()

  deselectNode = () => this.reactElement && this.reactElement.setSelected(false)

  // Generally avoids 'index out of range' errors
  ignoreMutation = () => true

  stopEvent = (evt: SyntheticEvent<any>) => {
    if (
      evt.type === 'keypress' ||
      evt.type === 'input' ||
      evt.type === 'keydown' ||
      evt.type === 'keyup' ||
      evt.type === 'paste' ||
      evt.type === 'mousedown'
    ) {
      return true
    }
    return false
  }
}
