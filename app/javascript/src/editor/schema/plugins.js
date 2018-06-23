import 'prosemirror-tables/style/tables.css'
import 'prosemirror-gapcursor/style/gapcursor.css'

import { columnResizing, tableEditing } from 'prosemirror-tables'

import { dropCursor } from 'prosemirror-dropcursor'
import { gapCursor } from 'prosemirror-gapcursor'
import { history } from 'prosemirror-history'
import keys from './keys'
import placeholder from 'editor/plugins/placeholder'
import rules from './rules'

export default [
  rules,
  keys,
  placeholder(),
  dropCursor(),
  gapCursor(),
  history(),
  columnResizing(),
  tableEditing()
]

// for tables
document.execCommand('enableObjectResizing', false, false)
document.execCommand('enableInlineTableEditing', false, false)
