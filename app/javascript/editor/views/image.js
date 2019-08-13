// @flow

import * as Rails from 'rails-ujs'

import { Node as ProsemirrorNode, Schema } from 'prosemirror-model'
import { html, render } from 'lit-html'

import BaseView from './base'
import type { BaseViewPropType } from './base'
import { EditorView } from 'prosemirror-view'

export default class ImageView extends BaseView {
  constructor(props: BaseViewPropType) {
    super(props, false)

    this.containerNode = document.createElement('div')
    this.renderElement()
  }

  renderElement = () => {
    render(
      html`
        <lazy-image
          src=${this.node.attrs.src || ''}
          alt=${this.node.attrs.alt || ''}
          title=${this.node.attrs.title || this.node.attrs.alt || ''}
          .handleChange=${this.handleChange}
        ></lazy-image>
      `,
      this.containerNode
    )

    this.dom = this.containerNode
  }

  handleChange = (attrs: ?{ align: String, alt: string } = {}) => {
    this.node.attrs = Object.assign({}, this.node.attrs, attrs)
    this.renderElement()
    this.view.dispatch(this.view.state.tr.setNodeMarkup(this.getPos(), null, this.node.attrs))
  }

  stopEvent = () => true
}
