// @flow

import { Decoration, DecorationSet, EditorView } from 'prosemirror-view'
import { EditorState, Plugin, PluginKey, Transaction } from 'prosemirror-state'

import EditionItem from './item'
import { Element } from 'editor/base'

function createInlineDecoration(from, to, edition) {
  const cssClass = edition.state === 'merged' ? 'edition bg-blue-lightest' : 'edition bg-red-lightest'
  return Decoration.inline(from, to, { class: cssClass }, { edition })
}

class EditionState {
  decorations: DecorationSet

  constructor(decos: DecorationSet) {
    this.decorations = decos
  }

  findEdition(id: number) {
    let current = this.decorations.find()

    for (let i = 0; i < current.length; i++) if (current[i].spec.edition.id == id) return current[i]
  }

  editionsAt(pos: number) {
    return this.decorations.find(pos, pos)
  }

  apply(tr: Transaction) {
    let action = tr.getMeta(editionPlugin)
    let actionType = action ? action.type : null

    if (!action && !tr.docChanged) return this

    let decos = this.decorations
    decos = decos.map(tr.mapping, tr.doc)

    if (actionType == 'newEdition') {
      decos = decos.add(tr.doc, [createInlineDecoration(action.from, action.to, action.edition)])
    } else if (actionType == 'updateEdition') {
      const edition = this.findEdition(action.id)
      if (edition) edition.spec.edition = action.edition
    } else if (actionType === 'mergeEdition') {
      const edition = this.findEdition(action.id)
      if (edition) edition.spec.edition.state = 'merged'
    } else if (actionType == 'deleteEdition') {
      const edition = this.findEdition(action.id)
      decos = decos.remove([edition])
    }

    return new EditionState(decos)
  }

  static init(state: EditorState) {
    let decos = state.editions.map((c) => createInlineDecoration(c.from, c.to, new EditionItem(c.text, c.previousText)))
    return new EditionState(DecorationSet.create(state.doc, decos))
  }
}

export const editionPlugin = new Plugin({
  key: new PluginKey('edition'),
  state: {
    init: EditionState.init,
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

export default class Edition extends Element {
  name = 'edition'

  get plugins() {
    return [editionPlugin]
  }
}
