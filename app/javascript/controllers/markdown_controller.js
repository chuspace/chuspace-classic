// @flow
/** @jsx h */

import { h, render } from 'preact'

import { CodeBlock } from '@chuspace/editor-ui'
import { Controller } from 'stimulus'

export default class extends Controller {
  connect() {
    this.element.querySelectorAll('pre').forEach(codeNode => {
      const mode = codeNode.childNodes[0].className
      const getCMInstance = instance => (this.cm = instance)
      const content = codeNode.textContent

      const div = document.createElement('div')
      codeNode.parentNode.insertBefore(div, codeNode)
      codeNode.remove()

      render(<CodeBlock content={content} mode={mode} getCMInstance={getCMInstance} readOnly="noCursor" />, div)
    })
  }
}
