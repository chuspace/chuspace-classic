// @flow

import { LitElement, customElement, html } from 'lit-element'

import EventManager from '../../editor/src/js/eventManager'
import MarkdownEditor from '../../editor/src/js/markdownEditor'
import { ToastMark } from '@toast-ui/toastmark'

export default class CodeEditor extends LitElement {
  cm: typeof CodeMirror

  static get properties() {
    return {
      mode: { type: String, reflect: true },
      readonly: { type: String },
      theme: { type: String },
      content: { type: String, reflect: true }
    }
  }

  async connectedCallback() {
    await super.connectedCallback()

    this.lines = this.content.split(/\r\n|\r|\n/).length

    try {
      this.readonly = JSON.parse(this.readonly)
    } catch (e) {}

    const codeNode = this.querySelector('.chu-editor')

    this.toastMark = new ToastMark('', {
      disallowedHtmlBlockTags: ['br'],
      extendedAutolinks: false,
      referenceDefinition: false,
      disallowDeepHeading: true,
      customParser: {},
      frontMatter: false
    })

    const options = {
      previewStyle: 'tab',
      previewHighlight: false,
      initialEditType: 'markdown',
      height: '300px',
      minHeight: '200px',
      language: 'en-US',
      useDefaultHTMLSanitizer: true,
      useCommandShortcut: true,
      usageStatistics: false,
      toolbarItems: [
        'heading',
        'bold',
        'italic',
        'strike',
        'divider',
        'hr',
        'quote',
        'divider',
        'ul',
        'ol',
        'task',
        'indent',
        'outdent',
        'divider',
        'table',
        'image',
        'link',
        'divider',
        'code',
        'codeblock'
      ],
      hideModeSwitch: false,
      linkAttribute: null,
      extendedAutolinks: false,
      customConvertor: null,
      customHTMLRenderer: null,
      referenceDefinition: false,
      customHTMLSanitizer: null,
      frontMatter: false
    }

    this.cm = MarkdownEditor.factory(codeNode, new EventManager(), this.toastMark, options)
    this.cm.setPlaceholder('Write your post')
    this.cm.setValue('', true)

    console.log(this.cm)
  }

  createRenderRoot() {
    return this
  }

  initClipboardJS = (node: ?HTMLElement) => {
    const clipboard = new ClipboardJS(node, { text: (trigger) => this.cm && this.cm.getDoc().getValue() })

    clipboard.on('success', (e) => {
      this.cm && this.cm.execCommand('selectAll')
      const instance = tippy(node, {
        arrow: true,
        showOnCreate: true,
        trigger: 'click',
        content: 'Copied'
      })

      setTimeout(() => {
        this.cm && this.cm.execCommand('undoSelection')
        instance.destroy()
      }, 1000)
    })
  }

  render = () => {
    return html`
      <div class="code-editor-container code-editor-container--light" contenteditable="false">
        <div class="chu-editor"></div>
      </div>
    `
  }
}

document.addEventListener('turbolinks:load', () => {
  if (!window.customElements.get('code-editor')) {
    customElements.define('code-editor', CodeEditor)
  }
})
