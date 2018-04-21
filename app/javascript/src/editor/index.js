// @flow
import type { Value, Change } from 'slate'

import * as React from 'react'
import { Editor } from 'slate-react'
import EditPrism from 'slate-prism'
import EditBlockquote from 'slate-edit-blockquote'
import EditList from 'slate-edit-list'
import PluginEditCode from 'slate-edit-code'
import BLOCKS from 'markup-it/lib/constants/blocks'
import MARKS from 'markup-it/lib/constants/marks'
import INLINES from 'markup-it/lib/constants/inlines'
import 'prismjs/themes/prism.css'
import 'github-markdown-css'

import { DEFAULT as DEFAULT_LIST } from 'editor/helpers/list'
import * as editorPlugins from 'editor/plugins'

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
  ...Object.values(editorPlugins).map((f) => f.call())
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
        <Editor
          value={value}
          plugins={plugins}
          onChange={onChange}
          {...rest}
        />
      </div>
    )
  }
}
