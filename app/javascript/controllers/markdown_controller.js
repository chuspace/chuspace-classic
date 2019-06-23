// @flow

import { html, render } from 'lit-html'

import { CodeBlock } from 'editor/components'
import { Controller } from 'stimulus'

export default class extends Controller {
  connect() {
    this.element.querySelectorAll('pre').forEach(codeNode => {
      const mode = codeNode.childNodes[0].className
      const content = codeNode.textContent

      const onInit = instance => {
        instance.setValue(content)
        instance.setOption('mode', mode)
        setTimeout(() => {
          instance.refresh()
        }, 100)
      }

      const div = document.createElement('div')
      codeNode.parentNode.insertBefore(div, codeNode)
      codeNode.remove()
      const lines = content.split(/\r\n|\r|\n/).length

      render(
        html`
          <code-editor mode=${mode} readonly="nocursor" lines=${lines} theme="light" .onInit=${onInit}></code-editor>
        `,
        div
      )
    })
  }
}
