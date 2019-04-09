import * as marks from 'editor/marks'
import * as nodes from 'editor/nodes'
import * as plugins from 'editor/plugins'

import { DOMSerializer, Schema } from 'prosemirror-model'
import { EditorState, Plugin, PluginKey } from 'prosemirror-state'
import { baseKeymap, selectParentNode } from 'prosemirror-commands'
import { getMarkAttrs, isMarkActive, isNodeActive } from 'editor/helpers'
import { inputRules, undoInputRule } from 'prosemirror-inputrules'

import CodeBlockView from 'editor/nodeviews/code-block'
import { EditorView } from 'prosemirror-view'
import { ElementManager } from 'editor/utils'
import { dropCursor } from 'prosemirror-dropcursor'
import { gapCursor } from 'prosemirror-gapcursor'
import { keymap } from 'prosemirror-keymap'
import { markdownParser } from 'editor/markdown'
import toArray from 'lodash/toArray'

export default class Editor {
  constructor (options = {}) {
    this.options = options
    this.element = options.element
    this.extensions = this.createExtensions()
    this.nodes = this.createNodes()
    this.marks = this.createMarks()
    this.schema = this.createSchema()
    this.plugins = this.createPlugins()
    this.keymaps = this.createKeymaps()
    this.inputRules = this.createInputRules()
    this.pasteRules = this.createPasteRules()
    this.state = this.createState()
    this.view = this.createView()
    this.commands = this.createCommands()
    this.setActiveNodesAndMarks()
    this.focus()

    // give extension manager access to our view
    this.extensions.view = this.view
  }

  createExtensions () {
    return new ElementManager([
      ...toArray(marks).map(Mark => new Mark()),
      ...toArray(plugins).map(Plugin => new Plugin()),
      ...toArray(nodes).map(Node => new Node())
    ])
  }

  createPlugins () {
    return this.extensions.plugins
  }

  createKeymaps () {
    return this.extensions.keymaps({
      schema: this.schema
    })
  }

  createInputRules () {
    return this.extensions.inputRules({
      schema: this.schema
    })
  }

  createPasteRules () {
    return this.extensions.pasteRules({
      schema: this.schema
    })
  }

  createCommands () {
    return this.extensions.commands({
      schema: this.schema,
      view: this.view,
      editable: true
    })
  }

  createNodes () {
    console.log(this.extensions)
    return this.extensions.nodes
  }

  createMarks () {
    return this.extensions.marks
  }

  createSchema () {
    return new Schema({
      nodes: this.nodes,
      marks: this.marks
    })
  }

  createState () {
    return EditorState.create({
      schema: this.schema,
      doc: markdownParser(this.schema).parse(''),
      plugins: [
        ...this.plugins,
        inputRules({
          rules: this.inputRules
        }),
        ...this.pasteRules,
        ...this.keymaps,
        keymap({
          Backspace: undoInputRule,
          Escape: selectParentNode
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

  createView () {
    const view = new EditorView(this.element, {
      state: this.state,
      dispatchTransaction: this.dispatchTransaction.bind(this),
      nodeViews: {
        code_block: (node, view, getPos) =>
          new CodeBlockView(node, view, this.schema, getPos)
      }
    })

    view.dom.style.whiteSpace = 'pre-wrap'
    view.dom.classList = ''
    view.dom.classList.add('chu-editor')

    view.dom.addEventListener('focus', event =>
      view.dom.classList.add('focused')
    )

    view.dom.addEventListener('blur', event =>
      view.dom.classList.remove('focused')
    )
    return view
  }

  dispatchTransaction (transaction) {
    this.state = this.state.apply(transaction)
    this.view.updateState(this.state)

    if (!transaction.docChanged) {
      return
    }

    this.emitUpdate(transaction)
  }

  emitUpdate (transaction) {
    console.log(this.getHTML())
  }

  focus () {
    this.view.focus()
  }

  blur () {
    this.view.dom.blur()
  }

  setActiveNodesAndMarks () {
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

  getMarkAttrs (type = null) {
    return this.activeMarkAttrs[type]
  }

  get isActive () {
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

  getHTML () {
    const div = document.createElement('div')
    const fragment = DOMSerializer.fromSchema(this.schema).serializeFragment(
      this.state.doc.content
    )

    div.appendChild(fragment)

    return div.innerHTML
  }

  getJSON () {
    return this.state.doc.toJSON()
  }

  destroy () {
    if (!this.view) {
      return
    }

    this.view.destroy()
  }
}
