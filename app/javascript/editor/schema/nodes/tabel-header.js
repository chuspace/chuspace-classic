import { Node } from 'editor/base'
import TableNodes from './tabel-nodes'

export default class TableHeader extends Node {
  name = 'table_header'

  get schema() {
    return TableNodes.table_header
  }
}
