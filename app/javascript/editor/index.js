import * as marks from 'editor/marks'
import * as nodes from 'editor/nodes'
import * as plugins from 'editor/plugins'

import { DOMSerializer, Schema } from 'prosemirror-model'
import { EditorState, Plugin, PluginKey } from 'prosemirror-state'
import { baseKeymap, selectParentNode } from 'prosemirror-commands'
import { inputRules, undoInputRule } from 'prosemirror-inputrules'

import { EditorView } from 'prosemirror-view'
import { ElementManager } from 'editor/utils'
import { MarkdownParser } from 'prosemirror-markdown'
import { dropCursor } from 'prosemirror-dropcursor'
import { gapCursor } from 'prosemirror-gapcursor'
import { keymap } from 'prosemirror-keymap'
import markdownit from 'markdown-it'
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
      doc: this.createDocument(''),
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

  createDocument (content) {
    return new MarkdownParser(
      this.schema,
      markdownit('commonmark', { html: false }),
      {
        blockquote: { block: 'blockquote' },
        paragraph: { block: 'paragraph' },
        list_item: { block: 'list_item' },
        unordered_list: { block: 'unordered_list' },
        ordered_list: {
          block: 'ordered_list',
          getAttrs: tok => ({ order: +tok.attrGet('order') || 1 })
        },
        heading: {
          block: 'heading',
          getAttrs: tok => ({ level: +tok.tag.slice(1) })
        },
        code_block: { block: 'code_block' },
        fence: {
          block: 'code_block',
          getAttrs: tok => ({ params: tok.info || '' })
        },
        horizontal_rule: { node: 'horizontal_rule' },
        image: {
          node: 'image',
          getAttrs: tok => ({
            src: tok.attrGet('src'),
            title: tok.attrGet('title') || null,
            alt: (tok.children[0] && tok.children[0].content) || null
          })
        },
        hardbreak: { node: 'hard_break' },

        em: { mark: 'em' },
        strong: { mark: 'strong' },
        link: {
          mark: 'link',
          getAttrs: tok => ({
            href: tok.attrGet('href'),
            title: tok.attrGet('title') || null
          })
        },
        code_inline: { mark: 'code' }
      }
    ).parse(content)
  }

  createView () {
    const view = new EditorView(this.element, {
      state: this.state,
      dispatchTransaction: this.dispatchTransaction.bind(this)
    })

    view.dom.style.whiteSpace = 'pre-wrap'

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
