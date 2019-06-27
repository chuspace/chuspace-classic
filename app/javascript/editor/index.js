// @flow

import { CodeBlockView, ImageView } from 'editor/views'
import { EditorState, Plugin, PluginKey, Transaction } from 'prosemirror-state'
import { baseKeymap, selectParentNode } from 'prosemirror-commands'
import { getMarkAttrs, isMarkActive, isNodeActive } from 'editor/helpers'
import { inputRules, undoInputRule } from 'prosemirror-inputrules'
import { manager, schema } from 'editor/schema'
import { markdownParser, markdownSerializer } from 'editor/markdowner'

import { EditorView } from 'prosemirror-view'
import { Schema } from 'prosemirror-model'
import { Selection } from 'prosemirror-state'
import { dropCursor } from 'prosemirror-dropcursor'
import { gapCursor } from 'prosemirror-gapcursor'
import { keymap } from 'prosemirror-keymap'

function arrowHandler(dir) {
  return (state, dispatch, view) => {
    if (state.selection.empty && view.endOfTextblock(dir)) {
      let side = dir == 'left' || dir == 'up' ? -1 : 1,
        $head = state.selection.$head
      let nextPos = Selection.near(state.doc.resolve(side > 0 ? $head.after() : $head.before()), side)

      if (nextPos.$head && nextPos.$head.parent.type.name == 'code_block') {
        dispatch(state.tr.setSelection(nextPos))
        return true
      }
    }
    return false
  }
}

export default class Editor {
  options = {}
  element: HTMLElement
  keymaps: any
  content: string
  inputRules: []
  pasteRules: []
  state: EditorState
  view: EditorView
  commands: []
  activeMarks: {}
  activeNodes: {}
  activeMarkAttrs: {}

  constructor(options = {}) {
    this.options = options
    this.element = options.element
    this.keymaps = this.createKeymaps()
    this.inputRules = this.createInputRules()
    this.pasteRules = this.createPasteRules()
    this.state = this.createState()
    this.view = this.createView()
    this.commands = this.createCommands()
    this.setActiveNodesAndMarks()
    if (this.options.autoFocus) this.focus()
  }

  createKeymaps() {
    return manager.keymaps({
      schema: schema
    })
  }

  createInputRules() {
    return manager.inputRules({
      schema: schema
    })
  }

  createPasteRules() {
    return manager.pasteRules({
      schema: schema
    })
  }

  createCommands() {
    return manager.commands({
      schema: schema,
      view: this.view,
      editable: true
    })
  }

  createState() {
    return EditorState.create({
      schema: schema,
      doc: markdownParser.parse(this.options.content),
      plugins: [
        ...manager.plugins,
        inputRules({
          rules: this.inputRules
        }),
        ...this.pasteRules,
        ...this.keymaps,
        keymap({
          Backspace: undoInputRule,
          Escape: selectParentNode,
          ArrowLeft: arrowHandler('left'),
          ArrowRight: arrowHandler('right'),
          ArrowUp: arrowHandler('up'),
          ArrowDown: arrowHandler('down')
        }),
        keymap(baseKeymap),
        dropCursor(this.options.dropCursor),
        gapCursor(),
        new Plugin({
          key: new PluginKey('editable'),
          props: {
            editable: () => true
          }
        }),
        new Plugin({
          props: {
            attributes: {
              tabindex: 0
            }
          }
        })
      ]
    })
  }

  createView() {
    const view = new EditorView(this.element, {
      state: this.state,
      dispatchTransaction: this.dispatchTransaction.bind(this),
      nodeViews: {
        code_block: (node, view, getPos) => new CodeBlockView({ node, view, getPos }),
        image: (node, view, getPos) => new ImageView({ node, view, getPos })
      }
    })

    view.dom.style.whiteSpace = 'pre-wrap'
    view.dom.classList.add('chu-editor')

    return view
  }

  dispatchTransaction(transaction: Transaction) {
    this.state = this.state.apply(transaction)
    this.view.updateState(this.state)

    if (!transaction.docChanged) {
      return
    }

    this.emitUpdate(transaction)
  }

  emitUpdate(transaction: Transaction) {
    this.options.onChange()
  }

  focus() {
    this.view.focus()
  }

  blur() {
    this.view.dom.blur()
  }

  setActiveNodesAndMarks() {
    this.activeMarks = Object.entries(schema.marks).reduce(
      (marks, [name, mark]) => ({
        ...marks,
        [name]: (attrs = {}) => isMarkActive(this.state, mark, attrs)
      }),
      {}
    )

    this.activeMarkAttrs = Object.entries(schema.marks).reduce(
      (marks, [name, mark]) => ({
        ...marks,
        [name]: getMarkAttrs(this.state, mark)
      }),
      {}
    )

    this.activeNodes = Object.entries(schema.nodes).reduce(
      (nodes, [name, node]) => ({
        ...nodes,
        [name]: (attrs = {}) => isNodeActive(this.state, node, attrs)
      }),
      {}
    )
  }

  getMarkAttrs(type: ?string = null) {
    return this.activeMarkAttrs[type]
  }

  get isActive() {
    return Object.entries({
      ...this.activeMarks,
      ...this.activeNodes
    }).reduce(
      (types, [name, value]) => ({
        ...types,
        [name]: (attrs = {}) => value(attrs)
      }),
      {}
    )
  }

  getMarkdown() {
    const markdown = markdownSerializer.serialize(this.state.doc)
    console.log(markdown)
    return markdown
  }

  getTitle() {
    return this.state.doc.firstChild.textContent
  }

  destroy() {
    if (!this.view) {
      return
    }

    this.view.destroy()
  }
}
