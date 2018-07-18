// @flow

import './style.css'

import { EditorState, PluginKey, Selection } from 'prosemirror-state'
import React, { PureComponent } from 'react'

import { DOMParser } from 'prosemirror-model'
import { EditorView } from 'prosemirror-view'
import type { Node } from 'react'
import ReactView from 'editor/schema/react-view'
import createSchema from 'editor/schema'
import { getBasePlugins } from 'editor/schema/plugins'

type Props = {
  initialContent: any,
  editorId: string,
  onChange: (content: any) => void,
  children: Node,
  placeholder: string,
  isReadOnly: boolean,
  showHeaderLinks: boolean,
  renderStaticMarkup: boolean
}

type State = {
  view: any,
  editorState: any,
  transaction: any,
  pluginKeys: any
}

export default class Editor extends PureComponent<Props, State> {
  static defaultProps = {
    initialContent: {
      type: 'doc',
      attrs: { meta: {} },
      content: [{ type: 'paragraph' }]
    },
    editorId: undefined,
    onChange: undefined,
    children: undefined,
    placeholder: undefined,
    isReadOnly: false,
    showHeaderLinks: false,
    renderStaticMarkup: false
  }

  _isMounted: boolean = false
  containerId: null | string = null

  view: EditorView
  editorElement: ?HTMLDivElement
  schema: any
  pluginsObject: any
  nodeViews: any

  state = {
    view: null,
    editorState: null,
    transaction: null,
    pluginKeys: {}
  }

  constructor (props: Props) {
    super(props)
    this.containerId = 'chu-editor-container'
    this.schema = this.configureSchema()
    this.pluginsObject = this.configurePlugins(this.schema)
    this.nodeViews = this.configureNodeViews(this.schema)
  }

  componentDidMount () {
    this._isMounted = true
    this.createEditor()
  }

  componentWillUnmount () {
    this._isMounted = false
  }

  getJSON = () => this.view.state.doc.toJSON()

  getText = () => this.view.state.doc.textContent

  getPlugin = (key: string) => {
    if (this.state.pluginKeys[key]) {
      return this.state.pluginKeys[key].get(this.state.editorState)
    }
    return null
  }

  importHtml = (htmlString: string) => {
    /* Create wrapper DOM node */
    const wrapperElem = document.createElement('div')

    /* Insert htmlString into wrapperElem to generate full DOM tree */
    wrapperElem.innerHTML = htmlString

    /* Generate new ProseMirror doc from DOM node */
    const newDoc = DOMParser.fromSchema(this.schema).parse(wrapperElem)

    /* Create transaction and set selection to the beginning of the doc */
    const tr = this.view.state.tr
    tr.setSelection(Selection.atStart(this.view.state.doc))

    /* Insert each node of newDoc to current doc */
    /* Note, we don't want to just replaceSelectionWith(newDoc) */
    /* because it will add a doc within a doc. */
    newDoc.content.content.forEach(node => {
      tr.replaceSelectionWith(node)
    })

    /* Dispatch transaction to setSelection and insert content */
    this.view.dispatch(tr)
  }

  focus = () => this.view.focus()

  configurePlugins = (schema: any) => {
    const pluginKeys = {}

    let plugins = getBasePlugins({
      schema,
      isReadOnly: this.props.isReadOnly,
      placeholder: this.props.placeholder
    })

    if (this.props.children) {
      React.Children.forEach(this.props.children, child => {
        if (child && child.type.getPlugins) {
          const key = new PluginKey(child.type.pluginName)
          pluginKeys[child.type.pluginName] = key
          const addonPlugins = child.type.getPlugins({
            ...child.props,
            pluginKey: key,
            getPlugin: this.getPlugin
          })
          plugins = plugins.concat(addonPlugins)
        }
      })
    }
    return { plugins, pluginKeys }
  }

  configureNodeViews = (schema: any) => {
    const nodeViews = {}
    const nodes = schema.nodes
    Object.keys(nodes).forEach(nodeName => {
      const nodeSpec = nodes[nodeName].spec
      if (nodeSpec.toEditable) {
        nodeViews[nodeName] = (node, view, getPos, decorations) => {
          return new ReactView(
            node,
            view,
            getPos,
            decorations,
            this.props.isReadOnly
          )
        }
      }
    })

    return nodeViews
  }

  configureSchema = () => {
    const schemaNodes = {}
    const schemaMarks = {}
    if (this.props.children) {
      React.Children.forEach(this.props.children, child => {
        if (child && child.type.schema) {
          const { nodes, marks } = child.type.schema(child.props)
          Object.keys(nodes || {}).forEach(key => {
            schemaNodes[key] = nodes[key]
          })
          Object.keys(marks || {}).forEach(key => {
            schemaMarks[key] = marks[key]
          })
        }
      })
    }
    const schema = createSchema(schemaNodes, schemaMarks)
    return schema
  }

  createEditor = () => {
    this.state = EditorState.create({
      doc: this.schema.nodeFromJSON(this.props.initialContent),
      schema: this.schema,
      plugins: this.pluginsObject.plugins
    })

    this.view = new EditorView(this.editorElement, {
      state: this.state,
      dispatchTransaction: this.onAction,
      spellcheck: true,
      editable: () => !this.props.isReadOnly,
      nodeViews: this.nodeViews
    })

    this.setState({
      view: this.view,
      editorState: this.state,
      pluginKeys: this.pluginsObject.pluginKeys
    })

    this.view.focus()
  }

  onAction = (transaction: any) => {
    if (this._isMounted && this.view && this.view.state) {
      const newState = this.view.state.apply(transaction)
      this.view.updateState(newState)
      this.setState({ editorState: newState, transaction: transaction })
      if (this.props.onChange && transaction.docChanged) {
        this.props.onChange(this.view.state.doc.toJSON())
      }
    }
  }

  renderStatic = (nodeArray: any) => {
    return nodeArray.map((node, index) => {
      let children
      if (node.content) {
        children = this.renderStatic(node.content)
      }
      if (node.type === 'text') {
        const marks = node.marks || []
        children = marks.reduce((prev, curr) => {
          const MarkComponent = this.schema.marks[curr.type].spec.toStatic(
            curr,
            prev
          )
          return MarkComponent
        }, node.text)
      }

      const nodeWithIndex = node
      nodeWithIndex.currIndex = index
      const NodeComponent = this.schema.nodes[node.type].spec.toStatic(
        nodeWithIndex,
        children,
        this.props
      )
      return NodeComponent
    })
  }

  render () {
    if (!this._isMounted && this.props.renderStaticMarkup) {
      return this.renderStatic(this.props.initialContent.content)
    }

    return (
      <div style={{ position: 'relative' }} id={this.containerId}>
        {this.state.view
          ? React.Children.map(this.props.children, child => {
            if (!child) {
              return null
            }

            return React.cloneElement(child, {
              view: this.state.view,
              editorState: this.state.editorState,
              transaction: this.state.transaction,
              containerId: this.containerId,
              pluginKey: this.state.pluginKeys[child.type.pluginName]
            })
          })
          : null}

        {!this._isMounted && (
          <div className='chu-editor'>
            <div className='editor-body'>
              {this.renderStatic(this.props.initialContent.content)}
            </div>
          </div>
        )}
        <div
          ref={elem => {
            this.editorElement = elem
          }}
          className='chu-editor'
        />
      </div>
    )
  }
}
