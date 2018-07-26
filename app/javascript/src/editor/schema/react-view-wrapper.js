// @flow

import { Decoration, EditorView } from 'prosemirror-view'
import React, { Component } from 'react'

import { NodeType } from 'prosemirror-model'

type Props = {
  node: NodeType,
  view: EditorView,
  decorations: Decoration,
  forceSelection: () => void,
  updateAttrs: () => void,
  updateContent: () => void,
  changeNode: () => void,
  getPos: () => void,
  renderComponent: (
    node: NodeType,
    view: EditorView,
    decorations: Decoration,
    isSelected: boolean,
    helperFunctions: any
  ) => void
}

type State = {
  isSelected: boolean
}

class ReactViewWrapper extends Component<Props, State> {
  rootElem: ?HTMLElement

  constructor (props: Props) {
    super(props)
    this.state = {
      isSelected: false
    }
  }

  setSelected = (isSelected: boolean) => {
    this.setState({ isSelected })
  }

  forceSelection = (evt: SyntheticEvent<any>) => {
    if (!this.state.isSelected) {
      this.setState({ isSelected: true })
      this.props.forceSelection()
    }

    evt.stopPropagation()
  }

  focusAndSelect = () => {
    this.setState({ isSelected: true })
    this.rootElem && this.rootElem.focus()
  }

  render () {
    const { renderComponent, node, view, decorations } = this.props
    const helperFunctions = {
      updateAttrs: this.props.updateAttrs,
      changeNode: this.props.changeNode,
      updateContent: this.props.updateContent,
      getPos: this.props.getPos
    }
    return (
      <span
        ref={elem => (this.rootElem = elem)}
        draggable='false'
        onClick={this.forceSelection}
      >
        {renderComponent(
          node,
          view,
          decorations,
          this.state.isSelected,
          helperFunctions
        )}
      </span>
    )
  }
}

export default ReactViewWrapper
