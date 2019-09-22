// @flow

import * as marks from './nodes'
import * as nodes from './marks'
import * as plugins from 'editor/plugins'

import { ellipsis, emDash, smartQuotes } from 'prosemirror-inputrules'

import { Schema } from 'prosemirror-model'
import { keymap } from 'prosemirror-keymap'
import toArray from 'lodash/toArray'

class SchemaManager {
  elements: []

  constructor(elements: [] = []) {
    this.elements = elements
  }

  get nodes() {
    return this.elements
      .filter(element => element.type === 'node')
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
      .filter(element => element.type === 'mark')
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
      .filter(element => element.plugins)
      .reduce((allPlugins, { plugins }) => [...allPlugins, ...plugins], [])
  }

  keymaps({ schema }: any): Array<any> {
    const elementKeymaps = this.elements
      .filter(element => ['element'].includes(element.type))
      .filter(element => element.keys)
      .map(element => element.keys({ schema }))

    const nodeMarkKeymaps = this.elements
      .filter(element => ['node', 'mark'].includes(element.type))
      .filter(element => element.keys)
      .map(element =>
        element.keys({
          type: schema[`${element.type}s`][element.name],
          schema
        })
      )

    return [...elementKeymaps, ...nodeMarkKeymaps].map(keys => keymap(keys))
  }

  inputRules({ schema }: any): [] {
    const elementInputRules = this.elements
      .filter(element => ['element'].includes(element.type))
      .filter(element => element.inputRules)
      .map(element => element.inputRules({ schema }))

    const nodeMarkInputRules = this.elements
      .filter(element => ['node', 'mark'].includes(element.type))
      .filter(element => element.inputRules)
      .map(element =>
        element.inputRules({
          type: schema[`${element.type}s`][element.name],
          schema
        })
      )

    const otherRules = [smartQuotes.concat(ellipsis, emDash)]

    return [...elementInputRules, ...nodeMarkInputRules, ...otherRules].reduce(
      (allInputRules, inputRules) => [...allInputRules, ...inputRules],
      []
    )
  }

  pasteRules({ schema }: any) {
    const elementPasteRules = this.elements
      .filter(element => ['element'].includes(element.type))
      .filter(element => element.pasteRules)
      .map(element => element.pasteRules({ schema }))

    const nodeMarkPasteRules = this.elements
      .filter(element => ['node', 'mark'].includes(element.type))
      .filter(element => element.pasteRules)
      .map(element =>
        element.pasteRules({
          type: schema[`${element.type}s`][element.name],
          schema
        })
      )

    return [...elementPasteRules, ...nodeMarkPasteRules].reduce(
      (allPasteRules, pasteRules) => [...allPasteRules, ...pasteRules],
      []
    )
  }

  commands({ schema, view, editable }: any): any {
    return this.elements
      .filter(element => element.commands)
      .reduce((allCommands, element) => {
        const { name, type } = element
        const commands = {}
        const value = element.commands({
          schema,
          ...(['node', 'mark'].includes(type)
            ? {
                type: schema[`${type}s`][name]
              }
            : {})
        })

        if (Array.isArray(value)) {
          commands[name] = attrs =>
            value.forEach(callback => {
              if (!editable) {
                return false
              }
              view.focus()
              return callback(attrs)(view.state, view.dispatch, view)
            })
        } else if (typeof value === 'function') {
          commands[name] = attrs => {
            if (!editable) {
              return false
            }
            view.focus()
            return value(attrs)(view.state, view.dispatch, view)
          }
        } else if (typeof value === 'object') {
          Object.entries(value).forEach(([commandName, commandValue]) => {
            if (Array.isArray(commandValue)) {
              commands[commandName] = attrs =>
                commandValue.forEach(callback => {
                  if (!editable) {
                    return false
                  }
                  view.focus()
                  return callback(attrs)(view.state, view.dispatch, view)
                })
            } else {
              commands[commandName] = attrs => {
                if (!editable) {
                  return false
                }
                view.focus()
                return commandValue(attrs)(view.state, view.dispatch, view)
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

export const manager = new SchemaManager([
  ...toArray(marks).map(Mark => new Mark()),
  ...toArray(plugins).map(Plugin => new Plugin()),
  ...toArray(nodes).map(Node => new Node())
])

export const schema = new Schema({
  nodes: manager.nodes,
  marks: manager.marks
})
