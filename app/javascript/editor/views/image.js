// @flow

import { Node as ProsemirrorNode, Schema } from 'prosemirror-model'

import BaseView from './base'
import type { BaseViewPropType } from './base'
import { EditorView } from 'prosemirror-view'
import { render } from 'preact'

export default class ImageView extends BaseView {
  constructor(props: BaseViewPropType) {
    super(props, false)

    this.containerNode = document.createElement('figure')
    this.renderElement()
  }

  renderElement = () => {
    render(
      this.node.type.spec.toStatic(this.node, this.options, this.isSelected, this.view.editable, this.handleAltChange),
      this.containerNode
    )

    this.dom = this.containerNode
  }

  handleAltChange = (newAlt: string) => {
    this.node.attrs.alt = newAlt
    this.renderElement()
  }

  stopEvent = () => true
}
