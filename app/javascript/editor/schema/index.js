// @flow

import * as marks from 'editor/schema/nodes'
import * as nodes from 'editor/schema/marks'
import * as plugins from 'editor/plugins'

import { ellipsis, emDash, smartQuotes } from 'prosemirror-inputrules'

import Editor from '..'
import { Schema } from 'prosemirror-model'
import { keymap } from 'prosemirror-keymap'
import toArray from 'lodash/toArray'

export default class SchemaManager {
  elements: []
  schema: Schema
  editor: Editor

  constructor(editor: Editor) {
    this.elements = [
      ...toArray(marks).map((Mark) => new Mark(editor.options)),
      ...toArray(plugins).map((Plugin) => new Plugin(editor.options)),
      ...toArray(nodes).map((Node) => new Node(editor.options))
    ]

    this.elements.forEach((element) => {
      element.bindEditor(editor)
      element.init()
    })

    this.schema = new Schema({
      nodes: this.nodes,
      marks: this.marks
    })

    this.editor = editor
  }

  get nodes() {
    return this.elements
      .filter((element) => element.type === 'node')
      .reduce(
        (nodes, { name, schema }) => ({
          ...nodes,
          [name]: schema
        }),
        {}
      )
  }

  get marks() {
    return this.elements
      .filter((element) => element.type === 'mark')
      .reduce(
        (marks, { name, schema }) => ({
          ...marks,
          [name]: schema
        }),
        {}
      )
  }

  get plugins(): Array<any> {
    return this.elements
      .filter((element) => element.plugins)
      .reduce((allPlugins, { plugins }) => [...allPlugins, ...plugins], [])
  }

  get keymaps(): Array<any> {
    const elementKeymaps = this.elements
      .filter((element) => ['element'].includes(element.type))
      .filter((element) => element.keys)
      .map((element) => element.keys({ schema: this.schema }))

    const nodeMarkKeymaps = this.elements
      .filter((element) => ['node', 'mark'].includes(element.type))
      .filter((element) => element.keys)
      .map((element) =>
        element.keys({
          type: this.schema[`${element.type}s`][element.name],
          schema: this.schema
        })
      )

    return [...elementKeymaps, ...nodeMarkKeymaps].map((keys) => keymap(keys))
  }

  get inputRules(): [] {
    const elementInputRules = this.elements
      .filter((element) => ['element'].includes(element.type))
      .filter((element) => element.inputRules)
      .map((element) => element.inputRules({ schema: this.schema }))

    const nodeMarkInputRules = this.elements
      .filter((element) => ['node', 'mark'].includes(element.type))
      .filter((element) => element.inputRules)
      .map((element) =>
        element.inputRules({
          type: this.schema[`${element.type}s`][element.name],
          schema: this.schema
        })
      )

    const otherRules = [smartQuotes.concat(ellipsis, emDash)]

    return [...elementInputRules, ...nodeMarkInputRules, ...otherRules].reduce(
      (allInputRules, inputRules) => [...allInputRules, ...inputRules],
      []
    )
  }

  get pasteRules(): [] {
    const elementPasteRules = this.elements
      .filter((element) => ['element'].includes(element.type))
      .filter((element) => element.pasteRules)
      .map((element) => element.pasteRules({ schema: this.schema }))

    const nodeMarkPasteRules = this.elements
      .filter((element) => ['node', 'mark'].includes(element.type))
      .filter((element) => element.pasteRules)
      .map((element) =>
        element.pasteRules({
          type: this.schema[`${element.type}s`][element.name],
          schema: this.schema
        })
      )

    return [...elementPasteRules, ...nodeMarkPasteRules].reduce(
      (allPasteRules, pasteRules) => [...allPasteRules, ...pasteRules],
      []
    )
  }

  get commands() {
    return this.elements
      .filter((element) => element.commands)
      .reduce((allCommands, element) => {
        const { name, type } = element
        const commands = {}
        const value = element.commands({
          schema: this.schema,
          ...(['node', 'mark'].includes(type)
            ? {
                type: this.schema[`${type}s`][name]
              }
            : {})
        })

        if (Array.isArray(value)) {
          commands[name] = (attrs) =>
            value.forEach((callback) => {
              if (!this.editor.options.editable) {
                return false
              }
              this.editor.view.focus()
              return callback(attrs)(this.editor.view.state, this.editor.view.dispatch, this.editor.view)
            })
        } else if (typeof value === 'function') {
          commands[name] = (attrs) => {
            if (!this.editor.options.editable) {
              return false
            }
            this.editor.view.focus()
            return value(attrs)(this.editor.view.state, this.editor.view.dispatch, this.editor.view)
          }
        } else if (typeof value === 'object') {
          Object.entries(value).forEach(([commandName, commandValue]: [string, Function]) => {
            if (Array.isArray(commandValue)) {
              commands[commandName] = (attrs) =>
                commandValue.forEach((callback: Function) => {
                  if (!this.editor.options.editable) {
                    return false
                  }
                  this.editor.view.focus()
                  return callback(attrs)(this.editor.view.state, this.editor.view.dispatch, this.editor.view)
                })
            } else {
              commands[commandName] = (attrs) => {
                if (!this.editor.options.editable) {
                  return false
                }
                this.editor.view.focus()
                return commandValue(attrs)(this.editor.view.state, this.editor.view.dispatch, this.editor.view)
              }
            }
          })
        }

        return {
          ...allCommands,
          ...commands
        }
      }, {})
  }
}
