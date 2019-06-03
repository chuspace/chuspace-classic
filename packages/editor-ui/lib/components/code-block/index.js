// @flow

/** @jsx h */

import 'codemirror/lib/codemirror.css'
import './styles.sass'
import './themes/one-light.sass'
import './themes/one-dark.sass'
import 'codemirror/mode/javascript/javascript'
import 'codemirror/addon/edit/matchbrackets'
import 'codemirror/addon/edit/closebrackets'
import 'codemirror/addon/edit/matchtags'
import 'codemirror/addon/edit/trailingspace'
import 'codemirror/addon/edit/closetag'
import 'codemirror/addon/display/placeholder'
import 'codemirror/addon/display/autorefresh'

import * as CodeMirror from 'codemirror'

import { Component, h, render } from 'preact'
import { MODES, loadMode } from '@chuspace/code-editor-modes'

import ClipboardJS from 'clipboard'
import { EditorView } from 'prosemirror-view'

const SVG_RATIO = 0.81

const Copy = props => {
  const width = SVG_RATIO * 16

  return (
    <svg
      class="codemirror-copy"
      width={width}
      height={16}
      viewBox="0 0 13 16"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
    >
      <path
        d="M8 0H3.40385C2.55385 0 1.84615 0.669231 1.84615 1.51923V1.84615H1.55769C0.707692 1.84615 0 2.51538 0 3.36538V14.4423C0 15.2923 0.707692 16 1.55769 16H9.55769C10.4077 16 11.0769 15.2923 11.0769 14.4423V14.1538H11.4038C12.2538 14.1538 12.9231 13.4462 12.9231 12.5962V4.92308L8 0ZM8 1.71538L11.2077 4.92308H8V1.71538ZM9.84615 14.4423C9.84615 14.6231 9.71538 14.7692 9.55769 14.7692H1.55769C1.38846 14.7692 1.23077 14.6115 1.23077 14.4423V3.36538C1.23077 3.20769 1.37692 3.07692 1.55769 3.07692H1.84615V12.9038C1.84615 13.7538 2.24615 14.1538 3.09615 14.1538H9.84615V14.4423ZM11.6923 12.5962C11.6923 12.7769 11.5615 12.9231 11.4038 12.9231H3.40385C3.23462 12.9231 3.07692 12.7654 3.07692 12.5962V1.51923C3.07692 1.36154 3.22308 1.23077 3.40385 1.23077H6.76923V6.15385H11.6923V12.5962Z"
        fill={'black'}
      />
    </svg>
  )
}

const Controls = props => (
  <svg class="codemirror-controls" xmlns="http://www.w3.org/2000/svg" width="54" height="14" viewBox="0 0 54 14">
    <g fill="none" fillRule="evenodd" transform="translate(1 1)">
      <circle cx="6" cy="6" r="6" fill="#FF5F56" stroke="#E0443E" strokeWidth=".5" onClick={props.destroy} />
      <circle cx="26" cy="6" r="6" fill="#FFBD2E" stroke="#DEA123" strokeWidth=".5" />
      <circle cx="46" cy="6" r="6" fill="#27C93F" stroke="#1AAB29" strokeWidth=".5" />
    </g>
  </svg>
)

type Props = {
  mode: string,
  setMode: (mode: string) => void
}

type State = {
  mode: string,
  showSwitcher: boolean
}

class LanguageSwitcher extends Component<Props, State> {
  props: EditorView

  constructor(props) {
    super(props)

    this.state = {
      mode: props.mode,
      showSwitcher: false
    }
  }

  toggleSwitcher = e => {
    this.setState({
      showSwitcher: !this.state.showSwitcher
    })
  }

  handleLanguageChange = e => {
    e.preventDefault()

    const mode = e.target.dataset.mode
    this.setState({ mode, showSwitcher: false })
    this.props.setMode(mode)
  }

  render() {
    return this.props.readOnly ? (
      <div class="codemirror-language-badge">{this.props.mode}</div>
    ) : (
      <div class="codemirror-language-switcher-container">
        <input type="text" value={this.state.mode} class="codemirror-language-input" onFocus={this.toggleSwitcher} />
        {this.state.showSwitcher && (
          <ul class="codemirror-language-switcher">
            {MODES.map(({ name, mode }) => (
              <li onClick={this.handleLanguageChange} data-mode={mode}>
                {name}
              </li>
            ))}
          </ul>
        )}
      </div>
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
  }

  initClipboardJS = node => new ClipboardJS(node, { text: trigger => this.props.cm.getDoc().getValue() })

  render() {
    return (
      <div class="codemirror-toolbar">
        <Controls destroy={this.props.destroy} />
        <div class="codemirror-toolbar-menu">
          <LanguageSwitcher {...this.props} />{' '}
          <div ref={this.initClipboardJS} data-clipboard-target=".CodeMirror-code">
            <Copy />
          </div>
        </div>
      </div>
    )
  }
}

export default class Container extends Component {
  cm: ?CodeMirror

  state = {
    cm: null
  }

  setMode = async (mode: string) => {
    await loadMode(mode)
    this.state.cm && this.state.cm.setOption('mode', mode)
    this.props.handleLanguageChange && this.props.handleLanguageChange(mode)
  }

  createCM = async (node: ?HTMLElement) => {
    await loadMode(this.props.mode)
    const cm = new CodeMirror(node, {
      value: this.props.content,
      lineNumbers: true,
      smartIndent: !this.props.readOnly,
      readOnly: this.props.readOnly || false,
      mode: this.props.mode,
      indentWithTabs: !this.props.readOnly,
      theme: 'one-light',
      autofocus: !this.props.readOnly,
      addModeClass: true,
      lineWrapping: true,
      autoCloseBrackets: true,
      autoCloseTags: true,
      showTrailingSpace: true,
      matchTags: true,
      autoRefresh: { delay: 500 },
      placeholder: `Start writing ${this.props.mode} code...`,
      extraKeys: this.props.codeMirrorKeymap && this.props.codeMirrorKeymap()
    })

    this.setState({ cm })

    this.props.onInit && this.props.onInit(this.cm)
  }

  render = () => {
    return (
      <div class="codemirror-container" contentEditable={false}>
        <Toolbar {...this.props} setMode={this.setMode} cm={this.state.cm} />
        <span ref={this.createCM} />
      </div>
    )
  }
}
