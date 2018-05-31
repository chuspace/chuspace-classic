import 'prismjs/themes/prism.css'
import 'github-markdown-css'

// @flow
import * as React from 'react'
import * as editorPlugins from 'editor/plugins'

import type { Change, Value } from 'slate'
import { Document, Value as EditorValue } from 'slate'

import BLOCKS from 'markup-it/lib/constants/blocks'
import Button from 'components/button'
import { DEFAULT as DEFAULT_LIST } from 'editor/helpers/list'
import EditBlockquote from 'slate-edit-blockquote'
import EditList from 'slate-edit-list'
import EditPrism from 'slate-prism'
import { Editor } from 'slate-react'
import Fullscreen from 'react-full-screen'
import INLINES from 'editor/constants/inlines'
import MARKS from 'markup-it/lib/constants/marks'
import { State as MarkdownParser } from 'markup-it'
import PluginEditCode from 'slate-edit-code'
import autoSavePlugin from 'editor/plugins/autosave'
import axiosClient from 'helpers/axios-client'
import classNames from 'classnames'
import html from 'markup-it/lib/html'
import markdown from 'markup-it/lib/markdown'
import schema from 'editor/schema'
import to from 'helpers/await-to'

const options = Object.assign({
  markdownOption: {
    blocks: BLOCKS,
    marks: MARKS,
    inlines: INLINES
  },
  prismOption: {
    onlyIn: node => node.type === BLOCKS.CODE,
    getSyntax: node => node.data.get('syntax')
  },
  codeOption: {
    onlyIn: node => node.type === BLOCKS.CODE
  },
  blockquoteOption: {},
  listOption: DEFAULT_LIST
})

const plugins = [
  EditPrism(options.prismOption),
  PluginEditCode(options.codeOption),
  EditBlockquote(options.blockquoteOption),
  EditList(options.listOption),
  autoSavePlugin(),
  ...Object.values(editorPlugins).map(f => f.call())
]

const mdParser = MarkdownParser.create(markdown)
const htmlSerializer = MarkdownParser.create(html)

type Props = {
  value: Value,
  onChange: (change: Change) => void,
  posts_path: string
}

type State = {
  value: Value,
  isFull: boolean
}

function renderPlaceholder (props) {
  const { node, parent, readOnly } = props
  let placeholder = null
  if (node.object !== 'block') return
  if (node.text) return

  const parentIsDocument = parent instanceof Document
  const firstHeading =
    node.type === 'header_one' &&
    parentIsDocument &&
    parent.nodes.first() === node

  const firstParagraph =
    !readOnly &&
    parentIsDocument &&
    node.type === 'paragraph' &&
    parent.nodes.get(1) === node &&
    parent.nodes.last() === node

  if (!(firstHeading || firstParagraph)) return

  switch (node.type) {
    case 'header_one':
      placeholder = 'Title'
      break
    case 'paragraph':
      placeholder = 'Write your post...'
      break
    default:
      break
  }

  return (
    <span
      contentEditable={false}
      style={{
        opacity: '0.3',
        position: 'absolute',
        pointerEvents: 'none',
        userSelect: 'none'
      }}
    >
      {placeholder}
    </span>
  )
}

export default class EditorComponent extends React.Component<Props, State> {
  constructor (props: Props) {
    super(props)
    const document = mdParser.deserializeToDocument('')

    this.state = {
      value: EditorValue.create({ document }),
      isFull: false
    }
  }

  goFull = () => {
    this.setState({ isFull: !this.state.isFull })
  }

  onChange = ({ value }: Value): void => {
    this.setState(
      {
        value
      },
      () => {
        console.log(htmlSerializer.serializeDocument(this.state.value.document))
        // console.log(mdParser.serializeDocument(this.state.value.document))
      }
    )
  }

  createPost = async (e: SyntheticEvent<HTMLButtonElement>) => {
    e.preventDefault()
    const title = this.state.value.document.nodes.first().text
    const markdown = mdParser.serializeDocument(this.state.value.document)
    const [error] = await to(
      axiosClient.post(this.props.posts_path, { markdown, title })
    )

    if (error) console.log(error)
  }

  render () {
    const { isFull, value } = this.state

    const containerClasses = classNames('pa2', {
      'v-100 overflow-y-scroll mt2': isFull,
      'h-auto overflow-y-auto': !isFull
    })

    const editorContainerClasses = classNames('pa2', {
      mt2: isFull,
      ma0: !isFull
    })

    return (
      <div className='markdown-body pv3 f4 lh-copy'>
        <Fullscreen
          enabled={isFull}
          onChange={isFull => this.setState({ isFull })}
        >
          <div classes={containerClasses}>
            <div classes={editorContainerClasses}>
              <Editor
                autoFocus
                value={value}
                plugins={plugins}
                renderPlaceholder={renderPlaceholder}
                schema={schema}
                onChange={this.onChange}
              />
              <Button
                title='Submit'
                onClick={this.createPost}
                className='center bg-black white bn mt3'
              />
            </div>
          </div>
        </Fullscreen>
      </div>
    )
  }
}
