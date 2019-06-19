// @flow

import { Node as ProsemirrorNode, Schema } from 'prosemirror-model'
import { Selection, TextSelection } from 'prosemirror-state'
import { redo, undo } from 'prosemirror-history'

import BaseView from './base'
import type { BaseViewPropType } from './base'
import CodeMirror from 'codemirror'
import { DEFAULT_MODE } from 'editor/modes'
import { EditorView } from 'prosemirror-view'
import { exitCode } from 'prosemirror-commands'
import { render } from 'preact'

export default class CodeBlockView extends BaseView {
  cm: typeof CodeMirror.defaults = null
  updating: boolean = false
  mode: string = DEFAULT_MODE
  content: string
  readOnly: boolean
  incomingChanges: boolean = false
  getCMInstance: () => CodeMirror
  onLanguageChange: (mode: string) => void

  constructor(props: BaseViewPropType) {
    // Call super but don't render the view
    super(props, false)
    // Custom attrs for code block node view
    this.mode = this.node.attrs.language
    this.content = this.node.textContent
    this.readOnly = false

    // Renders view component
    this.renderElement()
  }

  renderElement = () => {
    render(
      this.node.type.spec.toStatic(
        this.node,
        this.mode,
        this.content,
        this.readOnly,
        this.onInit,
        this.onLanguageChange,
        this.destroy
      ),
      this.containerNode
    )

    this.dom = this.containerNode
  }

  onInit = (cm: CodeMirror) => {
    this.cm = cm
    this.cm.setOption('extraKeys', this.codeMirrorKeymap())
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

    setTimeout(() => this.cm.refresh(), 100)
    this.cm.on('focus', () => this.forwardSelection())
  }

  /* Component calls to set cm instance mode and node attrs */
  onLanguageChange = (mode: string) => (this.node.attrs.language = mode)

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
    let anchor = this.cm.indexFromPos(this.cm.getCursor('anchor')) + offset
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
    if (!this.cm) return

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

  selectNode = () => this.cm.focus()
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
