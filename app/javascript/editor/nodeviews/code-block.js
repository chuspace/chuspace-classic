// @flow
/** @jsx el */

import 'codemirror/lib/codemirror.css'
import 'codemirror/mode/javascript/javascript'
import 'codemirror/theme/material.css'
import './styles.sass'

import { Node as ProsemirrorNode, Schema } from 'prosemirror-model'
import { Selection, TextSelection } from 'prosemirror-state'
import { redo, undo } from 'prosemirror-history'

import ClipboardJS from 'clipboard'
import CodeMirror from 'codemirror'
import { EditorView } from 'prosemirror-view'
import { el } from 'redom'
import { exitCode } from 'prosemirror-commands'
import languages from 'editor/languages'

class LanguageSwitcher {
  handleLanguageChange = e => {
    const name = e.target.value

    import(`codemirror/mode/${name}/${name}.js`).then(() =>
      this.cm.setOption('mode', name)
    )
  }
  constructor (cm) {
    this.cm = cm
    return (
      <select
        class="codemirror-language-switcher"
        onchange={this.handleLanguageChange}
      >
        <option selected>Select language</option>
        {languages.map(({ name }) => (
          <option value={name}>{name}</option>
        ))}
      </select>
    )
  }
}

class Header {
  clipboard: ?ClipboardJS
  switcher: ?HTMLElement

  constructor (cm, node) {
    this.switcher = new LanguageSwitcher(cm)
    this.clipboard = new ClipboardJS('#foo')

    return (
      <div class="codemirror-header">
        <div class="codemirror-header-heading">CODE</div>
        <div class="codemirror-header-menu">
          <div id="foo" data-clipboard-target=".CodeMirror-code">
            Copy to clipboard
          </div>
          {this.switcher}
        </div>
      </div>
    )
  }
}

export default class CodeBlockView {
  cm: typeof CodeMirror.defaults
  updating: boolean
  dom: Element
  view: EditorView
  schema: Schema
  getPos: () => number
  incomingChanges: boolean
  node: ProsemirrorNode

  constructor (
    node: ProsemirrorNode,
    view: EditorView,
    schema: Schema,
    getPos: () => number
  ) {
    // Store for later
    this.node = node
    this.view = view
    this.schema = schema
    this.getPos = getPos
    this.incomingChanges = false

    // Create a CodeMirror instance
    this.cm = new CodeMirror(null, {
      value: this.node.textContent,
      mode: 'javascript',
      smartIndent: true,
      indentWithTabs: true,
      theme: 'material',
      autofocus: true,
      addModeClass: true,
      extraKeys: this.codeMirrorKeymap()
    })

    const header = new Header(this.cm, this.cm.getWrapperElement())

    this.cm.getWrapperElement().appendChild(header)

    // The editor's outer node is our DOM representation
    this.dom = this.cm.getWrapperElement()

    // CodeMirror needs to be in the DOM to properly initialize, so
    // schedule it to update itself
    setTimeout(() => this.cm.refresh(), 20)

    // This flag is used to avoid an update loop between the outer and
    // inner editor
    this.updating = false
    // Propagate updates from the code editor to ProseMirror
    this.cm.on('beforeChange', () => (this.incomingChanges = true))
    // Propagate updates from the code editor to ProseMirror
    this.cm.on('cursorActivity', () => {
      if (!this.updating && !this.incomingChanges) this.forwardSelection()
    })

    this.cm.on('changes', () => {
      if (!this.updating) {
        this.valueChanged()
        this.forwardSelection()
      }
      this.incomingChanges = false
    })
    this.cm.on('focus', () => this.forwardSelection())
  }

  /**
   * when the code editor is focused,we can keep the selection of
   * the outer editor synchronized with the inner one,so that any
   * commands executed on the outer editor see an accurate selection
   */
  forwardSelection () {
    if (!this.cm.hasFocus()) return
    let state = this.view.state
    let selection = this.asProseMirrorSelection(state.doc)
    if (!selection.eq(state.selection)) {
      this.view.dispatch(state.tr.setSelection(selection))
    }
  }

  /**
   * when the actual content of the code editor is changed,the event handler
   * registered in the node view's constructor calls this method.it'll compare
   * the code block node's current value to the value in the editor,and dispatch
   * a transaction if there is a difference.
   */
  valueChanged (): void {
    let change = computeChange(this.node.textContent, this.cm.getValue())
    if (change) {
      let start = this.getPos() + 1
      let tr = this.view.state.tr.replaceWith(
        start + change.from,
        start + change.to,
        // @ts-ignore
        change.text ? this.schema.text(change.text) : null
      )
      this.view.dispatch(tr)
    }
  }

  /**
   * this helper function translates from a CodeMirror selction to a
   * ProseMirror selection.Because CodeMirror uses a line/column based
   * indexing system,indexFromPos is used to convert to an actual character
   * index.
   * @param doc
   */
  asProseMirrorSelection (doc: ProsemirrorNode<Schema>) {
    let offset = this.getPos() + 1
    // @ts-ignore
    let anchor = this.cm.indexFromPos(this.cm.getCursor('anchor')) + offset
    // @ts-ignore
    let head = this.cm.indexFromPos(this.cm.getCursor('head')) + offset
    return TextSelection.create(doc, anchor, head)
  }

  /**
   * Selections are also synchronized the other way,from ProseMirror to
   * CodeMirror,using the view's setSelection method.
   * @param anchor
   * @param head
   */
  setSelection (anchor: string, head: string): void {
    this.cm.focus()
    this.updating = true
    this.cm.setSelection(
      this.cm.posFromIndex(anchor),
      this.cm.posFromIndex(head)
    )
    this.updating = false
  }

  /**
   * the keymap also binds keys for undo and redo, which the outer editor will
   * handle, and for ctrl-enter, which, in ProseMirror's base keymap, createds
   * a new paragraph after a code block.
   */
  codeMirrorKeymap () {
    let view = this.view
    let mod = /Mac/.test(navigator.platform) ? 'Cmd' : 'Ctrl'
    // @ts-ignore
    return CodeMirror.normalizeKeyMap({
      Up: () => this.maybeEscape('line', -1),
      Left: () => this.maybeEscape('char', -1),
      Down: () => this.maybeEscape('line', 1),
      Right: () => this.maybeEscape('char', 1),
      [`${mod}-Z`]: () => undo(view.state, view.dispatch),
      [`Shift-${mod}-Z`]: () => redo(view.state, view.dispatch),
      [`${mod}-Y`]: () => redo(view.state, view.dispatch),
      'Ctrl-Enter': () => {
        if (exitCode(view.state, view.dispatch)) view.focus()
      }
    })
  }

  /**
   * A somewhat tricky aspect of nesting editor like this is handling cursor
   * motion across the edges of the inner editor. This node view will have to
   * take care of allowing the user to move the selection out of the code editor.
   * @param unit
   * @param dir
   */
  maybeEscape (unit: string, dir: number) {
    let pos = this.cm.getCursor()
    if (
      this.cm.somethingSelected() ||
      pos.line !== (dir < 0 ? this.cm.firstLine() : this.cm.lastLine()) ||
      (unit === 'char' &&
        pos.ch !== (dir < 0 ? 0 : this.cm.getLine(pos.line).length))
    ) {
      return CodeMirror.Pass
    }
    this.view.focus()
    let targetPos = this.getPos() + (dir < 0 ? 0 : this.node.nodeSize)
    let selection = Selection.near(this.view.state.doc.resolve(targetPos), dir)
    this.view.dispatch(
      this.view.state.tr.setSelection(selection).scrollIntoView()
    )
    this.view.focus()
  }

  /**
   * when an update comes in from the editor, for example because of an undo action,
   * we kind of have to do the inverse of what valueChanged did--check for text changes
   * and if present, propagate then from the outer to inner editor.
   * @param node
   */
  update (node: ProsemirrorNode<Schema>) {
    if (node.type !== this.node.type) return false
    this.node = node
    let change = computeChange(this.cm.getValue(), node.textContent)
    if (change) {
      this.updating = true
      this.cm.replaceRange(
        change.text,
        this.cm.posFromIndex(change.from),
        this.cm.posFromIndex(change.to)
      )
      this.updating = false
    }
    return true
  }

  selectNode () {
    this.cm.focus()
  }

  stopEvent () {
    return true
  }
}

function computeChange (oldVal: string, newVal: string) {
  if (oldVal === newVal) return null
  let start = 0

  let oldEnd = oldVal.length

  let newEnd = newVal.length
  while (
    start < oldEnd &&
    oldVal.charCodeAt(start) === newVal.charCodeAt(start)
  ) {
    ++start
  }
  while (
    oldEnd > start &&
    newEnd > start &&
    oldVal.charCodeAt(oldEnd - 1) === newVal.charCodeAt(newEnd - 1)
  ) {
    oldEnd--
    newEnd--
  }
  return { from: start, to: oldEnd, text: newVal.slice(start, newEnd) }
}
