// @flow

/** @jsx h */

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

import * as CodeMirror from 'codemirror'

import { Component, h, render } from 'preact'
import { MODES, loadMode } from '@chuspace/code-editor-modes'

import ClipboardJS from 'clipboard'
import Controls from './controls'
import { CopyClipboard } from '@chuspace/editor-ui'
import { EditorView } from 'prosemirror-view'
import LanguageSwitcher from './language-switcher'

type EditorProps = {
  mode: string,
  content: string,
  readOnly: boolean,
  onDestroy: () => void,
  onInit: ?(cm: CodeMirror) => void,
  codeMirrorKeymap: ?() => void,
  onLanguageChange: (mode: string) => void
}

type EditorState = {
  cm: CodeMirror
}

export default class Editor extends Component<EditorProps, EditorState> {
  state = {
    cm: null
  }

  setMode = async (mode: string) => {
    await loadMode(mode)

    this.state.cm && this.state.cm.setOption('mode', mode)
    this.props.onLanguageChange && this.props.onLanguageChange(mode)
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
      theme: 'chuspace-light',
      addModeClass: true,
      autoCloseBrackets: true,
      autoCloseTags: true,
      showTrailingSpace: true,
      matchTags: true,
      autoRefresh: { delay: 500 }
    })

    if (!this.props.content) {
      cm.refresh()
      cm.focus()
    }

    this.setState({ cm })
    this.props.onInit && this.props.onInit(cm)
  }

  initClipboardJS = (node: ?HTMLElement) =>
    new ClipboardJS(node, { text: trigger => this.state.cm && this.state.cm.getDoc().getValue() })

  render = () => {
    return (
      <div class="code-editor-container" contentEditable={false}>
        <div class="code-editor-toolbar">
          <Controls destroy={this.props.onDestroy} />
          <div class="code-editor-toolbar-menu">
            <LanguageSwitcher mode={this.props.mode} readOnly={this.props.readOnly} setMode={this.setMode} />
            <CopyClipboard initClipboardJS={this.initClipboardJS} />
          </div>
        </div>
        <span ref={this.createCM} />
      </div>
    )
  }
}
