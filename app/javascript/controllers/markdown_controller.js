// @flow
/** @jsx h */

import { h, render } from 'preact'

import { CodeBlock } from '@chuspace/editor-ui'
import { Controller } from 'stimulus'
import markdownit from 'markdown-it'

export default class extends Controller {
  connect() {
    const body = this.data.get('body')
    const md = markdownit('commonmark', { html: false })

    this.element.innerHTML = md.render(body)
    this.element.querySelectorAll('pre').forEach(codeNode => {
      const mode = codeNode.children[0].className.split('-')[1]
      const getCMInstance = instance => (this.cm = instance)
      const content = codeNode.textContent

      const div = document.createElement('div')
      codeNode.parentNode.insertBefore(div, codeNode)
      codeNode.remove()

      render(<CodeBlock content={content} mode={mode} getCMInstance={getCMInstance} readOnly="noCursor" />, div)
    })
  }
}
