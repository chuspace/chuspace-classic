import 'prosemirror-view/style/prosemirror.css'
import './style.sass'

import { DOMParser, DOMSerializer } from 'prosemirror-model'
import { editorPlugins, editorSchema } from 'editor/schema'

import CodeBlockView from 'editor/views/code-block'
import { EditorState } from 'prosemirror-state'
import { EditorView } from 'prosemirror-view'
import React from 'react'
import debounce from 'lodash/debounce'

const parser = schema => {
  const parser = DOMParser.fromSchema(schema)

  return content => {
    const container = document.createElement('article')
    container.innerHTML = content
    return parser.parse(container)
  }
}

const serializer = schema => {
  const serializer = DOMSerializer.fromSchema(schema)

  return content => {
    const container = document.createElement('article')
    container.appendChild(serializer.serializeFragment(content))
    return container.innerHTML
  }
}

class Editor extends React.Component {
  componentWillMount () {
    this.parse = parser(editorSchema)
    this.serialize = serializer(editorSchema)
  }

  onChange = debounce(
    value => {
      console.log(this.serialize(value))
    },
    1000,
    { maxWait: 5000 }
  )

  constructor (props) {
    super(props)

    this.state = {
      state: EditorState.create({
        schema: editorSchema,
        plugins: editorPlugins
      })
    }
  }

  createEditorView = node => {
    if (!this.view) {
      this.view = new EditorView(node, {
        state: this.state.state,
        dispatchTransaction: this.dispatchTransaction,
        nodeViews: {
          code_block (node, view, getPos) {
            return new CodeBlockView(node, view, getPos)
          }
        },
        attributes: {
          placeholder: this.props.placeholder
        }
      })

      this.view.focus()
    }
  }

  dispatchTransaction = transaction => {
    const state = this.view.state.apply(transaction)
    this.view.updateState(state)
    this.setState({ state })
    this.onChange(state.doc.content)
  }

  render () {
    return <div ref={this.createEditorView} />
  }
}

export default Editor
