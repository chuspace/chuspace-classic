// @flow

import 'codemirror/lib/codemirror.css'
import 'codemirror/mode/javascript/javascript'

import CodeMirror from 'codemirror'
import { Controller } from 'stimulus'
import markdownit from 'markdown-it'

export default class extends Controller {
  connect() {
    const body = this.data.get('body')
    const md = markdownit('commonmark', { html: false })

    this.element.innerHTML = md.render(body)

    this.element.querySelectorAll('pre').forEach(codeNode => {
      const mode = codeNode.children[0].className.split('-')[1]

      import(`codemirror/mode/${mode}/${mode}.js`).then(module => {
        console.log(module.default)
        this.cm = new CodeMirror(element => codeNode.parentNode.replaceChild(element, codeNode), {
          value: codeNode.textContent,
          readOnly: 'noCursor',
          scrollBarStyle: null,
          viewportMargin: Infinity,
          lineNumbers: true,
          lineWrapping: true,
          extraKeys: {
            'Shift-Tab': 'indentLess'
          },
          // negative values removes the cursor, undefined means default (530)
          cursorBlinkRate: -1,
          // needs to be able to refresh every 16ms to hit 60 frames / second
          pollInterval: 16
        })

        this.cm.setOption('mode', mode)
      })
    })
  }
}
