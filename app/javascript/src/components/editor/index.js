import 'prismjs/themes/prism.css'
import 'github-markdown-css'

// @flow
import * as React from 'react'
import * as editorPlugins from 'editor/plugins'

import type { Change, Value } from 'slate'
import { Document, Value as EditorValue } from 'slate'

import BLOCKS from 'markup-it/lib/constants/blocks'
import { DEFAULT as DEFAULT_LIST } from 'editor/helpers/list'
import EditBlockquote from 'slate-edit-blockquote'
import EditList from 'slate-edit-list'
import EditPrism from 'slate-prism'
import { Editor } from 'slate-react'
import Fullscreen from 'react-full-screen'
import INLINES from 'editor/constants/inlines'
import MARKS from 'markup-it/lib/constants/marks'
import { State as MarkdownParser } from 'markup-it'
import Placeholder from 'editor/renderers/placeholder'
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
    getIndent: Value => ' ',
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
  postsPath: string
}

type State = {
  value: Value,
  isFull: boolean
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
      axiosClient.post(this.props.postsPath, { markdown, title })
    )

    if (error) console.log(error)
  }

  render () {
    const { isFull, titleValue, value, tagsValue } = this.state

    const containerClasses = classNames('pa2', {
      'v-100 overflow-y-scroll mt2': isFull,
      'h-auto overflow-y-auto': !isFull
    })

    const editorContainerClasses = classNames('pa2', {
      mt2: isFull,
      ma0: !isFull
    })

    return (
      <div className='pv3 f4 lh-copy'>
        <Fullscreen
          enabled={isFull}
          onChange={isFull => this.setState({ isFull })}
        >
          <div className={containerClasses}>
            <div className={editorContainerClasses}>
              <div className='markdown-body'>
                <Editor
                  name='body'
                  style={{ minHeight: '30vh' }}
                  value={value}
                  plugins={plugins}
                  schema={schema}
                  placeholder='Write your post...'
                  onChange={this.onChange}
                />
              </div>
            </div>
          </div>
        </Fullscreen>
      </div>
    )
  }
}
