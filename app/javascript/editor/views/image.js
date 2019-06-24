// @flow

import { Node as ProsemirrorNode, Schema } from 'prosemirror-model'
import { html, render } from 'lit-html'

import BaseView from './base'
import type { BaseViewPropType } from './base'
import { EditorView } from 'prosemirror-view'

export default class ImageView extends BaseView {
  constructor(props: BaseViewPropType) {
    super(props, false)

    this.containerNode = document.createElement('figure')
    this.renderElement()
  }

  renderElement = () => {
    render(
      html`
        <lazy-image
          src=${this.node.attrs.src}
          alt=${this.node.attrs.alt}
          align=${this.node.attrs.align}
          width=${this.node.attrs.width}
          title=${this.node.attrs.title || this.node.attrs.alt}
          .handleAltChange=${this.handleAltChange}
        ></lazy-image>
      `,
      this.containerNode
    )

    this.dom = this.containerNode.children[0]
  }

  handleAltChange = (newAlt: string) => {
    this.node.attrs.alt = newAlt
    this.renderElement()
    this.view.dispatch(this.view.state.tr.setNodeMarkup(this.getPos(), null, this.node.attrs))
  }

  stopEvent = () => true
}
