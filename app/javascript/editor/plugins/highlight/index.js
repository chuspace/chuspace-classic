// @flow

import { Decoration, DecorationSet, EditorView } from 'prosemirror-view'
import { EditorState, Plugin, PluginKey, Transaction } from 'prosemirror-state'

import { Element } from 'editor/base'

class HighlightState {
  decorations: DecorationSet

  constructor(decos: DecorationSet) {
    this.decorations = decos
  }

  highlightsAt(pos: number) {
    return this.decorations.find(pos, pos)
  }

  apply(tr: Transaction) {
    let action = tr.getMeta('highlight')
    if (!action) return this

    let decos = this.decorations
    decos = decos.map(tr.mapping, tr.doc)

    const { fromPos, toPos } = tr.getMeta('highlight')

    console.log(this.highlightsAt(fromPos))

    if (action.type == 'add') {
      decos = decos.add(tr.doc, [Decoration.inline(fromPos, toPos, { class: 'selection bg-green-lightest' })])
    } else if (action.type == 'remove') {
      decos = decos.remove(this.highlightsAt(fromPos))
    }

    return new HighlightState(decos)
  }

  static init(state: EditorState) {
    return new HighlightState(DecorationSet.empty)
  }
}

export const highlightPlugin = new Plugin({
  key: new PluginKey('highlight'),
  state: {
    init: HighlightState.init,
    apply(tr, prev) {
      return prev.apply(tr)
    }
  },
  props: {
    decorations(state) {
      return this.getState(state).decorations
    }
  }
})

export default class Highlight extends Element {
  name = 'highlight'

  get plugins() {
    return [highlightPlugin]
  }
}
