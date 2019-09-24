// @flow

import { Change, ChangeSet, Span, simplifyChanges } from 'prosemirror-changeset'
import { CodeBlockView, ImageView } from 'editor/views'
import { Decoration, DecorationSet } from 'prosemirror-view'
import { EditorState, Plugin, PluginKey, Transaction } from 'prosemirror-state'
import { baseKeymap, selectParentNode } from 'prosemirror-commands'
import { getMarkAttrs, isMarkActive, isNodeActive } from 'editor/helpers'
import { inputRules, undoInputRule } from 'prosemirror-inputrules'
import { manager, schema } from 'editor/schema'
import { markdownParser, markdownSerializer } from 'editor/markdowner'

import { DOMSerializer } from 'prosemirror-model'
import { EditorView } from 'prosemirror-view'
import { Schema } from 'prosemirror-model'
import { Selection } from 'prosemirror-state'
import { Transform } from 'prosemirror-transform'
import { dropCursor } from 'prosemirror-dropcursor'
import { gapCursor } from 'prosemirror-gapcursor'
import get from 'lodash/get'
import { keymap } from 'prosemirror-keymap'
import { recreateTransform } from '@manuscripts/prosemirror-recreate-steps'
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
      editable: !!this.options.editable
    })
  }

  get plugins() {
    return [
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

  _computeDiffDocument() {
    // based on https://gitlab.com/mpapp-public/prosemirror-recreate-steps/blob/master/demo/history/index.js

    // recreate transform back to base doc
    let baseDoc = markdownParser.parse(this.options.original)
    let revisionDoc = markdownParser.parse(this.options.content)
    let tr = recreateTransform(revisionDoc, baseDoc, true, true)

    // create decorations corresponding to the changes
    let decorations = []
    let changeSet = ChangeSet.create(revisionDoc).addSteps(tr.doc, tr.mapping.maps)
    let changes = simplifyChanges(changeSet.changes, tr.doc)

    function isCodeBlock(slice) {
      return get(slice.content, 'content[0].type.name') === 'code_block'
    }

    let index = 0

    // deletion
    function findDeleteEndIndex(startIndex) {
      for (let i = startIndex; i < changes.length; i++) {
        // if we are at the end then that's the end index
        if (i === changes.length - 1) return i
        // if the next change is discontinuous then this is the end index
        if (changes[i].toB + 1 !== changes[i + 1].fromB) return i
      }
    }

    while (index < changes.length) {
      let endIndex = findDeleteEndIndex(index)
      decorations.push(Decoration.inline(changes[index].fromB, changes[endIndex].toB, { class: 'deletion' }, {}))
      index = endIndex + 1
    }

    // insertion
    function findInsertEndIndex(startIndex) {
      for (let i = startIndex; i < changes.length; i++) {
        // if we are at the end then that's the end index
        if (i === changes.length - 1) return i
        // if the next change is discontinuous then this is the end index
        if (changes[i].toA + 1 !== changes[i + 1].fromA) return i
      }
    }
    index = 0
    while (index < changes.length) {
      let endIndex = findInsertEndIndex(index)

      // apply the insertion
      let slice = revisionDoc.slice(changes[index].fromA, changes[endIndex].toA)
      let span = document.createElement('span')
      span.setAttribute('class', 'insertion')
      span.appendChild(DOMSerializer.fromSchema(schema).serializeFragment(slice.content))
      decorations.push(
        Decoration.widget(changes[index].toB, span, {
          marks: []
        })
      )

      index = endIndex + 1
    }

    // plugin to apply diff decorations
    const decorationSet = DecorationSet.create(tr.doc, decorations)
    let decosPlugin = new Plugin({
      key: new PluginKey('diffs'),
      props: {
        decorations() {
          return decorationSet
        }
      }
    })

    // return
    return {
      doc: tr.doc,
      plugins: [decosPlugin]
    }
  }

  createState = () => {
    let doc = markdownParser.parse(this.options.content)
    let plugins = this.plugins

    if (this.options.original) {
      let diff = this._computeDiffDocument()
      doc = diff.doc
      plugins = plugins.concat(diff.plugins)
    }

    return EditorState.create({
      schema: schema,
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

  get content() {
    const markdown = markdownSerializer.serialize(this.state.doc)
    return markdown
  }

  get title() {
    return this.state.doc.firstChild.textContent
  }

  get summary() {
    const summaryNode = this.state.doc.content.content[1]

    if (summaryNode && summaryNode.type.name === 'heading' && summaryNode.attrs.level === 2) {
      return summaryNode.textContent
    }

    return ''
  }

  destroy() {
    if (!this.view) {
      return
    }

    this.view.destroy()
  }
}
