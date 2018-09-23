import 'prosemirror-view/style/prosemirror.css'
import './style.sass'

import { editorPlugins, editorSchema } from 'editor/schema'

import { EditorState } from 'prosemirror-state'
import { EditorView } from 'prosemirror-view'
import debounce from 'lodash/debounce'

// import serializer from 'editor/markdown/serializer'

class Editor {
  onChange = debounce(
    value => {
      console.log(this.serialize(value))
    },
    1000,
    { maxWait: 5000 }
  )

  constructor (props) {
    this.props = props
    this.createEditorView(props.element)
  }

  createEditorView = node => {
    if (!this.view) {
      this.view = new EditorView(node, {
        state: EditorState.create({
          schema: editorSchema,
          plugins: editorPlugins
        }),
        dispatchTransaction: this.dispatchTransaction,
        attributes: {
          placeholder: 'Write something...'
        }
      })

      this.view.focus()
    }
  }

  dispatchTransaction = transaction => {
    const state = this.view.state.apply(transaction)
    this.view.updateState(state)
    console.log(this.view.state.doc)
  }
}

export default Editor
