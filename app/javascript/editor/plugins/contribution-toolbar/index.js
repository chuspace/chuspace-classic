// @flow

import { Decoration, DecorationSet, EditorView } from 'prosemirror-view'
import { EditorState, Plugin, PluginKey, TextSelection } from 'prosemirror-state'
import { html, render } from 'lit-html'

import EditionItem from '../edition/item'
import Editor from '../..'
import { Element } from 'editor/base'
import { Fragment } from 'prosemirror-model'
import autosize from 'autosize'
import { editionPlugin } from '../edition'
import { highlightPlugin } from '../highlight'
import { markdownSerializer } from 'editor/markdowner'

class Tooltip {
  tooltip: HTMLElement
  editor: HTMLElement
  state: EditorState
  view: EditorView
  editionText: ?string
  selectedText: ?string
  mainEditor: Editor

  constructor(view: EditorView, mainEditor: Editor) {
    this.editionText = null
    this.selectedText = null
    this.view = view
    this.mainEditor = mainEditor
    this.tooltip = document.createElement('div')
    this.tooltip.contentEditable = 'false'
    this.tooltip.className = 'absolute bg-white z-50 transform -translate-x-1/2'
  }

  handleEdit = (e: Event, edition: ?Decoration) => {
    e.preventDefault()

    this.tooltip.style.display = 'none'
    this.editor = document.createElement('div')
    this.editor.style.width = '700px'
    this.editor.contentEditable = 'false'
    this.editor.className = 'absolute bg-white border border-grey-lightest shadow-md z-50 transform -translate-x-1/2'
    this.selectedText = markdownSerializer.serialize(this.state.selection.content().content)

    render(this.editionMarkup(edition), this.editor)

    this.view.dom.parentNode.appendChild(this.editor)
    autosize(this.editor.querySelector('textarea'))

    let { from, to } = edition ? edition : this.state.selection

    this.view.dispatch(this.state.tr.setMeta('highlight', { type: 'add', fromPos: from, toPos: to }))

    // These are in screen coordinates
    let start = this.view.coordsAtPos(from),
      end = this.view.coordsAtPos(to)

    if (this.editor.offsetParent) {
      // The box in which the tooltip is positioned, to use as base
      let box = this.editor.offsetParent.getBoundingClientRect()
      // Find a center-ish x position from the selection endpoints (when
      // crossing lines, end may be more to the left)
      let left = Math.max((start.left + end.left) / 2, start.left + 3)
      this.editor.style.left = left - box.left + 'px'
      this.editor.style.bottom = box.bottom - start.top + 'px'
    }
  }

  handleMerge = (e, edition) => {
    this.view.dispatch(
      this.state.tr.setMeta(editionPlugin, {
        type: 'deleteEdition',
        id: edition.spec.edition.id
      })
    )

    edition.spec.edition.state = 'merged'
    this.view.dispatch(
      this.state.tr.setMeta(editionPlugin, {
        type: 'newEdition',
        from: edition.from,
        to: edition.to,
        edition: edition.spec.edition
      })
    )

    const nodes = this.mainEditor.markdownParser.parse('**hello**')
    const fragment = Fragment.from(nodes)

    this.view.dispatch(this.state.tr.replaceWith(edition.from, edition.to, fragment))
  }

  get tooltipMarkup() {
    return html`
      <div class="bg-grey-darkest rounded-md px-4 py-3 flex items-center">
        <svg-icon
          @click=${this.handleEdit}
          class="cursor-pointer"
          name="edit"
          width="20"
          height="20"
          feather="true"
          stroke="#fff"
          color="none"
        ></svg-icon>
        <svg-icon
          @click=${this.handleComment}
          name="message-circle"
          width="20"
          height="20"
          feather="true"
          stroke="#fff"
          color="none"
          class="ml-4 cursor-pointer"
        ></svg-icon>
        <div class="border-r border-white opacity-25 ml-4 mr-4" style="height:20px"></div>
        <svg-icon
          @click=${this.handleShare}
          class="cursor-pointer"
          name="twitter"
          width="20"
          height="20"
          feather="true"
          stroke="#fff"
          color="none"
        ></svg-icon>
      </div>
    `
  }

  renderEdition = (edition) => {
    return html`
      <div
        class="bg-green-lighter rounded-md px-4 py-3 break-words whitespace-normal p-4 text-base font-normal"
        style="min-width: 350px; max-width: 350px;"
      >
        ${edition.spec.edition.text}
        <svg-icon
          @click=${(e) => this.handleEdit(e, edition)}
          class="cursor-pointer"
          name="edit"
          width="20"
          height="20"
          feather="true"
          stroke="#fff"
          color="none"
        ></svg-icon>

        <svg-icon
          @click=${(e) => this.handleMerge(e, edition)}
          class="cursor-pointer"
          name="git-merge"
          width="20"
          height="20"
          feather="true"
          stroke="#fff"
          color="none"
        ></svg-icon>
      </div>
    `
  }

  setText = (e: SyntheticEvent<HTMLTextAreaElement>) => (this.editionText = e.currentTarget.value)

  createEdition = () => {
    let sel = this.state.selection
    const editions = editionPlugin.getState(this.state).editionsAt(sel.from)
    if (editions.length > 0) return false

    this.view.dispatch(this.state.tr.setMeta('highlight', { type: 'remove', fromPos: sel.from, toPos: sel.to }))

    if (this.view.dispatch && this.editionText && this.selectedText) {
      this.view.dispatch(
        this.state.tr.setMeta(editionPlugin, {
          type: 'newEdition',
          from: sel.from,
          to: sel.to,
          edition: new EditionItem(this.editionText, this.selectedText)
        })
      )
    }

    this.editor.remove()

    return true
  }

  updateEdition = (editionMeta) => {
    const edition = new EditionItem(this.editionText, this.selectedText)
    const meta = Object.assign({}, editionMeta, { edition })

    this.view.dispatch(
      this.state.tr.setMeta(editionPlugin, {
        ...meta,
        id: editionMeta.spec.edition.id,
        type: 'updateEdition'
      })
    )

    this.editor.remove()
    this.view.dispatch(
      this.state.tr.setMeta('highlight', { type: 'remove', fromPos: editionMeta.from, toPos: editionMeta.to })
    )

    return true
  }

  discardEdition = (e, edition: ?Decoration) => {
    e.preventDefault()

    if (edition) {
      this.view.dispatch(
        this.state.tr.setMeta(editionPlugin, {
          type: 'deleteEdition',
          id: edition.spec.edition.id
        })
      )

      this.view.dispatch(
        this.state.tr.setMeta('highlight', { type: 'remove', fromPos: edition.from, toPos: edition.to })
      )
    }

    if (!edition) {
      let sel = this.state.selection
      this.view.dispatch(this.state.tr.setMeta('highlight', { type: 'remove', fromPos: sel.from, toPos: sel.to }))
    }

    this.editor.remove()
  }

  editionMarkup(edition: ?Decoration) {
    const text = edition ? edition.spec.edition.previousText : this.selectedText
    const createText = edition ? 'Update' : 'Create'
    const deleteText = edition ? 'Remove' : 'Discard'
    const createFunc = edition ? () => this.updateEdition(edition) : this.createEdition
    const deleteFunc = (event) => (edition ? this.discardEdition(event, edition) : this.discardEdition(event))

    return html`
      <div class="w-full p-4">
        <span class="w-full bg-red-lighter break-words whitespace-normal">${text}</span>
        <textarea
          rows="2"
          class="w-full block my-4 border border-grey-lightest p-2 outline-none shadow-none"
          @change=${this.setText}
        >
${edition ? edition.spec.edition.text : null}</textarea
        >
        <div class="flex items-center justify-end">
          <button class="button button--active mr-2" @click=${createFunc}>${createText}</button>
          <button class="button button--default" @click=${deleteFunc}>${deleteText}</button>
        </div>
      </div>
    `
  }

  update(view, lastState) {
    let state = view.state
    this.state = state

    // Don't do anything if the document/selection didn't change
    if (lastState && lastState.doc.eq(state.doc) && lastState.selection.eq(state.selection)) return

    let sel = this.state.selection
    const editions = editionPlugin.getState(this.state).editionsAt(sel.from)

    // Hide the tooltip if the selection is empty or has editions
    if (state.selection.empty && !editions.length) {
      this.tooltip.style.display = 'none'
      return
    }

    if (editions.length > 0) {
      render(this.renderEdition(editions[0]), this.tooltip)
    } else {
      render(this.tooltipMarkup, this.tooltip)
    }

    view.dom.parentNode.appendChild(this.tooltip)

    // Otherwise, reposition it and update its content
    this.tooltip.style.display = ''

    let { from, to } = state.selection
    // These are in screen coordinates
    let start = view.coordsAtPos(from),
      end = view.coordsAtPos(to)

    if (this.tooltip.offsetParent) {
      // The box in which the tooltip is positioned, to use as base
      let box = this.tooltip.offsetParent.getBoundingClientRect()
      // Find a center-ish x position from the selection endpoints (when
      // crossing lines, end may be more to the left)
      let left = Math.max((start.left + end.left) / 2, start.left + 3)

      this.tooltip.style.left = left - box.left + 'px'
      this.tooltip.style.bottom = box.bottom - start.top + 'px'
    }
  }

  destroy() {
    this.tooltip.remove()
  }
}

export const tooltipPlugin = (editor: Editor) =>
  new Plugin({
    key: new PluginKey('tooltip'),
    view(editorView) {
      return new Tooltip(editorView, editor)
    }
  })

export class ContributionToolbar extends Element {
  name = 'tooltip'

  get plugins() {
    return [tooltipPlugin(this.editor)]
  }
}
