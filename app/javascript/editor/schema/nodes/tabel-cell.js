import { Node } from 'editor/base'
import TableNodes from './tabel-nodes'

export default class TableCell extends Node {
  name = 'table_cell'

  get schema() {
    return TableNodes.table_cell
  }
}
