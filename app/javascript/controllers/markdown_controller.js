// @flow

import { html, render } from 'lit-html'

import { Controller } from 'stimulus'

export default class extends Controller {
  connect() {
    let index = 0

    this.element.querySelectorAll('pre').forEach(codeNode => {
      const mode = codeNode.childNodes[0].className.split('-')[1]
      const content = codeNode.textContent

      const onInit = instance => {
        instance.setValue(content)
        instance.setOption('mode', mode)
        setTimeout(() => {
          instance.refresh()
        }, index * 10)
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

      index++
    })
  }
}
