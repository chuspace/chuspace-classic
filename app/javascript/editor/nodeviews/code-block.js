// @flow
/** @jsx h */

import 'codemirror/lib/codemirror.css'
import 'codemirror/mode/javascript/javascript'
import 'editor/themes/one-light.sass'
import 'editor/themes/one-dark.sass'

import { Node as ProsemirrorNode, Schema } from 'prosemirror-model'
import { Selection, TextSelection } from 'prosemirror-state'
import { h, render } from 'preact'
import { redo, undo } from 'prosemirror-history'

import CodeBlockComponent from 'editor/components/code-block'
import CodeMirror from 'codemirror'
import { EditorView } from 'prosemirror-view'
import { exitCode } from 'prosemirror-commands'

export default class CodeBlockView {
  cm: typeof CodeMirror.defaults
  updating: boolean
  dom: Element
  view: EditorView
  schema: Schema
  mode: string
  header: HTMLElement
  getPos: () => number
  incomingChanges: boolean
  node: ProsemirrorNode

  constructor(node: ProsemirrorNode, view: EditorView, schema: Schema, getPos: () => number) {
    // Store for later
    this.node = node
    this.view = view
    this.schema = schema
    this.getPos = getPos
    this.incomingChanges = false
    this.mode = this.node.attrs.language || 'javascript'

    const setCMInstance = instance => (this.cm = instance)

    let html = render(
      <CodeBlockComponent {...this} codeMirrorKeymap={this.codeMirrorKeymap} setCMInstance={setCMInstance} />,
      document.createElement('span')
    )

    this.dom = html

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

  handleLanguageChange = (mode: string = this.mode) => {
    this.cm.setOption('mode', mode)
    this.node.attrs.language = mode
  }

  /**
   * when the code editor is focused,we can keep the selection of
   * the outer editor synchronized with the inner one,so that any
   * commands executed on the outer editor see an accurate selection
   */
  forwardSelection = () => {
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
  valueChanged = (): void => {
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
  asProseMirrorSelection = (doc: ProsemirrorNode<Schema>) => {
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
  setSelection = (anchor: string, head: string): void => {
    this.cm.focus()
    this.updating = true
    this.cm.setSelection(this.cm.posFromIndex(anchor), this.cm.posFromIndex(head))
    this.updating = false
  }

  /**
   * the keymap also binds keys for undo and redo, which the outer editor will
   * handle, and for ctrl-enter, which, in ProseMirror's base keymap, createds
   * a new paragraph after a code block.
   */
  codeMirrorKeymap = () => {
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
  maybeEscape = (unit: string, dir: number) => {
    let pos = this.cm.getCursor()
    console.log(pos)
    if (
      this.cm.somethingSelected() ||
      pos.line !== (dir < 0 ? this.cm.firstLine() : this.cm.lastLine()) ||
      (unit === 'char' && pos.ch !== (dir < 0 ? 0 : this.cm.getLine(pos.line).length))
    ) {
      return CodeMirror.Pass
    }
    this.view.focus()
    let targetPos = this.getPos() + (dir < 0 ? 0 : this.node.nodeSize)
    let selection = Selection.near(this.view.state.doc.resolve(targetPos), dir)
    this.view.dispatch(this.view.state.tr.setSelection(selection).scrollIntoView())
    this.view.focus()
  }

  /**
   * when an update comes in from the editor, for example because of an undo action,
   * we kind of have to do the inverse of what valueChanged did--check for text changes
   * and if present, propagate then from the outer to inner editor.
   * @param node
   */
  update = (node: ProsemirrorNode<Schema>) => {
    if (node.type !== this.node.type) return false
    this.node = node
    let change = computeChange(this.cm.getValue(), node.textContent)
    if (change) {
      this.updating = true
      this.cm.replaceRange(change.text, this.cm.posFromIndex(change.from), this.cm.posFromIndex(change.to))
      this.updating = false
    }
    return true
  }

  selectNode = () => {
    this.cm.focus()
  }

  stopEvent = () => {
    return true
  }
}

function computeChange(oldVal: string, newVal: string) {
  if (oldVal === newVal) return null
  let start = 0

  let oldEnd = oldVal.length

  let newEnd = newVal.length
  while (start < oldEnd && oldVal.charCodeAt(start) === newVal.charCodeAt(start)) {
    ++start
  }
  while (oldEnd > start && newEnd > start && oldVal.charCodeAt(oldEnd - 1) === newVal.charCodeAt(newEnd - 1)) {
    oldEnd--
    newEnd--
  }
  return { from: start, to: oldEnd, text: newVal.slice(start, newEnd) }
}
