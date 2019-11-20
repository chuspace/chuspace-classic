// @flow

import * as marks from 'editor/schema/nodes'
import * as nodes from 'editor/schema/marks'
import * as plugins from 'editor/plugins'

import { Change, ChangeSet, Span, simplifyChanges } from 'prosemirror-changeset'
import { CodeBlockView, ImageView } from 'editor/views'
import { Decoration, DecorationSet } from 'prosemirror-view'
import { EditorState, Plugin, PluginKey, Transaction } from 'prosemirror-state'
import { baseKeymap, selectParentNode } from 'prosemirror-commands'
import { getMarkAttrs, isMarkActive, isNodeActive } from 'editor/helpers'
import { inputRules, undoInputRule } from 'prosemirror-inputrules'
import { markdownParser, markdownSerializer } from 'editor/markdowner'

import { DOMSerializer } from 'prosemirror-model'
import { EditorView } from 'prosemirror-view'
import { MarkdownParser } from 'prosemirror-markdown'
import { Schema } from 'prosemirror-model'
import SchemaManager from 'editor/schema'
import { Selection } from 'prosemirror-state'
import { Transform } from 'prosemirror-transform'
import { dropCursor } from 'prosemirror-dropcursor'
import { gapCursor } from 'prosemirror-gapcursor'
import get from 'lodash/get'
import { keymap } from 'prosemirror-keymap'
import toArray from 'lodash/toArray'
import without from 'lodash/without'

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

type Options = {
  autoFocus: boolean,
  element: HTMLElement,
  original: string,
  imageProviderPath: string,
  content: string,
  editable: boolean,
  onChange: () => void
}

export default class Editor {
  options = {}
  element: HTMLElement
  elements: SchemaManager
  schema: Schema
  markdownParser: MarkdownParser
  markdownSerializer: markdownSerializer
  keymaps: any
  inputRules: []
  pasteRules: []
  state: EditorState
  view: EditorView
  commands: []
  activeMarks: {}
  activeNodes: {}
  activeMarkAttrs: {}

  constructor(options: Options = {}) {
    this.options = options
    this.element = options.element
    this.elements = this.createElements()
    this.schema = this.createSchema()

    this.markdownParser = markdownParser(this.schema)
    this.markdownSerializer = markdownSerializer

    this.keymaps = this.createKeymaps()
    this.inputRules = this.createInputRules()
    this.pasteRules = this.createPasteRules()
    this.state = this.createState()
    this.view = this.createView()
    this.commands = this.createCommands()

    this.view.props.commands = this.commands
    this.setActiveNodesAndMarks()
    if (this.options.autoFocus) this.focus()
  }

  createElements() {
    return new SchemaManager(
      [
        ...toArray(marks).map(Mark => new Mark()),
        ...toArray(plugins).map(Plugin => new Plugin()),
        ...toArray(nodes).map(Node => new Node())
      ],
      this
    )
  }

  createSchema() {
    return new Schema({
      nodes: this.elements.nodes,
      marks: this.elements.marks
    })
  }

  createKeymaps() {
    return this.elements.keymaps({
      schema: this.schema
    })
  }

  createInputRules() {
    return this.elements.inputRules({
      schema: this.schema
    })
  }

  createPasteRules() {
    return this.elements.pasteRules({
      schema: this.schema
    })
  }

  createCommands() {
    return this.elements.commands({
      schema: this.schema,
      view: this.view,
      editable: !!this.options.editable
    })
  }

  get plugins() {
    return [
      ...this.elements.plugins,
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
        ArrowDown: arrowHandler('down'),
        'Ctrl-s': this.handleSave,
        'Mod-s': this.handleSave
      }),
      keymap(baseKeymap),
      dropCursor(),
      gapCursor(),
      new Plugin({
        key: new PluginKey('editable'),
        props: {
          editable: () => !!this.options.editable
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
  }

  createState = () => {
    const doc = this.markdownParser.parse(this.options.content)
    const plugins = this.plugins

    return EditorState.create({
      schema: this.schema,
      doc: doc,
      plugins
    })
  }

  createView() {
    let nodeViews = {
      code_block: (node, view, getPos) => new CodeBlockView({ node, view, getPos }),
      image: (node, view, getPos) => new ImageView({ node, view, getPos })
    }

    if (this.options.original) {
      nodeViews = {}
    }

    const view = new EditorView(this.element, {
      state: this.state,
      editable: () => !!this.options.editable,
      imageProviderPath: this.options.imageProviderPath,
      dispatchTransaction: this.dispatchTransaction.bind(this),
      nodeViews
    })

    view.dom.style.whiteSpace = 'pre-wrap'
    view.dom.classList.add('chu-editor')

    return view
  }

  handleSave = (e: Event) => {
    this.options.onChange()
    return true
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
    this.activeMarks = Object.entries(this.schema.marks).reduce(
      (marks, [name, mark]) => ({
        ...marks,
        [name]: (attrs = {}) => isMarkActive(this.state, mark, attrs)
      }),
      {}
    )

    this.activeMarkAttrs = Object.entries(this.schema.marks).reduce(
      (marks, [name, mark]) => ({
        ...marks,
        [name]: getMarkAttrs(this.state, mark)
      }),
      {}
    )

    this.activeNodes = Object.entries(this.schema.nodes).reduce(
      (nodes, [name, node]) => ({
        ...nodes,
        [name]: (attrs = {}) => isNodeActive(this.state, node, attrs)
      }),
      {}
    )
  }

  getMarkAttrs(type: string) {
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

  get content() {
    const markdown = this.markdownSerializer.serialize(this.state.doc)
    return markdown
  }

  destroy() {
    if (!this.view) {
      return
    }

    this.view.destroy()
  }
}
