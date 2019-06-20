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
import { MODES, loadMode } from 'editor/modes'

import ClipboardJS from 'clipboard'
import Controls from './controls'
import { CopyClipboard } from 'editor/components'
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
  cm: ?CodeMirror

  setMode = async (mode: string) => {
    await loadMode(mode)
    this.props.onLanguageChange && this.props.onLanguageChange(mode)
  }

  createCM = async (node: ?HTMLElement) => {
    await loadMode(this.props.mode)
    this.cm = new CodeMirror(node, {
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
      matchTags: true
    })

    this.props.onInit && this.props.onInit(this.cm)
    return this.cm
  }

  initClipboardJS = (node: ?HTMLElement) =>
    new ClipboardJS(node, { text: trigger => this.cm && this.cm.getDoc().getValue() })

  render = () => {
    return (
      <div class="code-editor-container code-editor-container--light" contentEditable={false}>
        <div class="code-editor-toolbar font-headings" contentEditable={false}>
          <Controls destroy={this.props.onDestroy} />
          <div class="code-editor-toolbar-menu" contentEditable={false}>
            <LanguageSwitcher mode={this.props.mode} readOnly={this.props.readOnly} setMode={this.setMode} />
            <CopyClipboard initClipboardJS={this.initClipboardJS} />
          </div>
        </div>

        <div className="code-editor">
          <span ref={this.createCM}></span>
        </div>
      </div>
    )
  }
}
