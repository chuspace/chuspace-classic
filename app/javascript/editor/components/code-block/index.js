// @flow

import 'codemirror/lib/codemirror.css'
import './styles.sass'
import './themes/light.sass'
import './themes/dark.sass'
import 'codemirror/mode/javascript/javascript'
import 'codemirror/addon/edit/matchbrackets'
import 'codemirror/addon/edit/closebrackets'
import 'codemirror/addon/edit/matchtags'
import 'codemirror/addon/edit/trailingspace'
import 'codemirror/addon/edit/closetag'
import 'codemirror/addon/display/autorefresh'
import './language-switcher'

import * as CodeMirror from 'codemirror'

import { LitElement, customElement, html } from 'lit-element'
import { MODES, loadMode } from 'editor/modes'

import ClipboardJS from 'clipboard'
import Controls from './controls'
import { CopyClipboard } from 'editor/components'
import { EditorView } from 'prosemirror-view'

export default class CodeEditor extends LitElement {
  cm: ?CodeMirror

  static get properties() {
    return {
      mode: { type: String, reflect: true },
      readonly: { type: String },
      theme: { type: String },
      lines: { type: Number },
      loaded: { type: Boolean },
      onInit: { type: Function },
      onLanguageChange: { type: Function },
      onDestroy: { type: Function }
    }
  }

  constructor() {
    super()
    this.loaded = false
  }

  setMode = async (mode: string) => {
    await loadMode(mode)

    this.mode = mode
    this.onLanguageChange(mode)
  }

  async connectedCallback() {
    super.connectedCallback()

    await loadMode(this.mode)

    try {
      this.readonly = JSON.parse(this.readonly)
    } catch (e) {}

    const codeNode = this.querySelector('.code-editor')
    this.cm = this.createCM(codeNode)
    this.onInit(this.cm)

    this.loaded = true
  }

  createRenderRoot() {
    return this
  }

  createCM = (node: ?HTMLElement) =>
    new CodeMirror(node, {
      lineNumbers: true,
      smartIndent: !this.readonly,
      readOnly: this.readonly || false,
      indentUnit: 2,
      indentWithTabs: !this.readonly,
      theme: `chuspace-${this.theme}`,
      addModeClass: true,
      autoCloseBrackets: !this.readonly,
      autoCloseTags: !this.readonly,
      showTrailingSpace: !this.readonly,
      matchTags: !this.readonly
    })

  initClipboardJS = (node: ?HTMLElement) =>
    new ClipboardJS(node, { text: trigger => this.cm && this.cm.getDoc().getValue() })

  render = () => {
    return html`
      <div class="code-editor-container code-editor-container--${this.theme}" contenteditable="false">
        <div class="code-editor-toolbar font-headings" contenteditable="false">
          ${Controls({ destroy: this.onDestroy })}
          <div class="code-editor-toolbar-menu" contenteditable="false">
            <code-editor-language-switcher
              mode=${this.mode}
              readonly=${this.readonly}
              .setMode=${this.setMode}
            ></code-editor-language-switcher>
            <copy-clipboard .initClipboardJS=${this.initClipboardJS}></copy-clipboard>
          </div>
        </div>

        <div class="code-editor">
          <span>
            ${!this.loaded
              ? html`
                  <content-loader
                    contentEditable="false"
                    lines=${this.lines}
                    class="block whitespace-no-wrap py-4"
                  ></content-loader>
                `
              : null}
          </span>
        </div>
      </div>
    `
  }
}

document.addEventListener('turbolinks:load', () => {
  if (!window.customElements.get('code-editor')) {
    customElements.define('code-editor', CodeEditor)
  }
})
