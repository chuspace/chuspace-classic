// @flow

/** @jsx h */

import './code-block.sass'

import { Component, h, render } from 'preact'

import ClipboardJS from 'clipboard'
import CodeMirror from 'codemirror'
import { EditorView } from 'prosemirror-view'
import { LANGUAGES } from 'editor/constants'

const SVG_RATIO = 0.81

const Copy = props => {
  const width = SVG_RATIO * 16

  return (
    <svg width={width} height={16} viewBox="0 0 13 16" fill="none" xmlns="http://www.w3.org/2000/svg">
      <path
        d="M8 0H3.40385C2.55385 0 1.84615 0.669231 1.84615 1.51923V1.84615H1.55769C0.707692 1.84615 0 2.51538 0 3.36538V14.4423C0 15.2923 0.707692 16 1.55769 16H9.55769C10.4077 16 11.0769 15.2923 11.0769 14.4423V14.1538H11.4038C12.2538 14.1538 12.9231 13.4462 12.9231 12.5962V4.92308L8 0ZM8 1.71538L11.2077 4.92308H8V1.71538ZM9.84615 14.4423C9.84615 14.6231 9.71538 14.7692 9.55769 14.7692H1.55769C1.38846 14.7692 1.23077 14.6115 1.23077 14.4423V3.36538C1.23077 3.20769 1.37692 3.07692 1.55769 3.07692H1.84615V12.9038C1.84615 13.7538 2.24615 14.1538 3.09615 14.1538H9.84615V14.4423ZM11.6923 12.5962C11.6923 12.7769 11.5615 12.9231 11.4038 12.9231H3.40385C3.23462 12.9231 3.07692 12.7654 3.07692 12.5962V1.51923C3.07692 1.36154 3.22308 1.23077 3.40385 1.23077H6.76923V6.15385H11.6923V12.5962Z"
        fill={'black'}
      />
    </svg>
  )
}

const Controls = props => (
  <svg xmlns="http://www.w3.org/2000/svg" width="54" height="14" viewBox="0 0 54 14">
    <g fill="none" fillRule="evenodd" transform="translate(1 1)">
      <circle cx="6" cy="6" r="6" fill="#FF5F56" stroke="#E0443E" strokeWidth=".5" />
      <circle cx="26" cy="6" r="6" fill="#FFBD2E" stroke="#DEA123" strokeWidth=".5" />
      <circle cx="46" cy="6" r="6" fill="#27C93F" stroke="#1AAB29" strokeWidth=".5" />
    </g>
  </svg>
)

class LanguageSwitcher extends Component {
  props: EditorView
  mode: string

  constructor(props) {
    super(props)
    this.props = props
    this.mode = props.mode
  }

  handleLanguageChange = e => {
    const name = e.target.value
    this.props.handleLanguageChange(name)
  }

  render(props) {
    return (
      <select class="codemirror-language-switcher" onchange={this.handleLanguageChange}>
        <option selected>Select language</option>
        {LANGUAGES.map(({ name, mode }) => (
          <option value={mode} selected={this.mode === mode}>
            {name}
          </option>
        ))}
      </select>
    )
  }
}

class Toolbar extends Component {
  view: EditorView
  clipboard: ?ClipboardJS
  switcher: ?HTMLElement
  controls: ?HTMLElement
  copy: ?HTMLElement

  constructor(props) {
    super(props)
    this.clipboard = new ClipboardJS('#foo')
  }

  render() {
    return (
      <div class="codemirror-toolbar">
        <Controls />
        <Copy />
        <div class="codemirror-toolbar-heading">CODE</div>
        <div class="codemirror-toolbar-menu">
          <div id="foo" data-clipboard-target=".CodeMirror-code">
            Copy to clipboard
          </div>
          <LanguageSwitcher {...this.props} />
          <div onclick={this.props.view.destroy}>remove</div>
        </div>
      </div>
    )
  }
}

export default class Container extends Component {
  createCM = node =>
    this.props.setCMInstance(
      new CodeMirror(node, {
        value: this.props.node.textContent,
        lineNumbers: true,
        smartIndent: true,
        mode: this.props.mode,
        indentWithTabs: true,
        theme: 'one-light',
        autofocus: true,
        addModeClass: true,
        lineWrapping: true,
        extraKeys: this.props.codeMirrorKeymap()
      })
    )

  render = () => {
    return (
      <div class="codemirror-container" contentEditable={false}>
        <Toolbar {...this.props} />
        <span ref={this.createCM} />
      </div>
    )
  }
}
