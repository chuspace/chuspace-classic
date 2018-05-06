// @flow

import 'prismjs/themes/prism.css'
import 'github-markdown-css'

import * as React from 'react'
import * as editorPlugins from 'editor/plugins'

import type { Change, Value } from 'slate'

import BLOCKS from 'markup-it/lib/constants/blocks'
import { DEFAULT as DEFAULT_LIST } from 'editor/helpers/list'
import EditBlockquote from 'slate-edit-blockquote'
import EditList from 'slate-edit-list'
import EditPrism from 'slate-prism'
import { Editor } from 'slate-react'
import INLINES from 'editor/constants/inlines'
import MARKS from 'markup-it/lib/constants/marks'
import PluginEditCode from 'slate-edit-code'

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
  ...Object.values(editorPlugins).map(f => f.call())
]

type Props = {
  value: Value,
  onChange: (change: Change) => void
}

export default class ChuEditor extends React.Component<Props> {
  render () {
    const { value, onChange, ...rest } = this.props

    return (
      <div className='markdown-body pv3 f4 lh-copy'>
        <Editor value={value} plugins={plugins} onChange={onChange} {...rest} />
      </div>
    )
  }
}
