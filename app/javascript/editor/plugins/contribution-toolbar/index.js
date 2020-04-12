// @flow

import { Decoration, DecorationSet, EditorView } from 'prosemirror-view'
import { EditorState, Plugin, PluginKey } from 'prosemirror-state'
import { html, render } from 'lit-html'

import EditionItem from '../edition/item'
import { Element } from 'editor/base'
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

  constructor(view: EditorView) {
    this.editionText = null
    this.selectedText = null
    this.view = view
    this.tooltip = document.createElement('div')
    this.tooltip.contentEditable = 'false'
    this.tooltip.className = 'absolute bg-white z-50 transform -translate-x-1/2'

    render(this.tooltipMarkup, this.tooltip)

    view.dom.parentNode.appendChild(this.tooltip)
    this.update(view, null)
  }

  handleEdit = (e: Event) => {
    e.preventDefault()

    this.tooltip.style.display = 'none'
    this.editor = document.createElement('div')
    this.editor.style.width = '700px'
    this.editor.contentEditable = 'false'
    this.editor.className = 'absolute bg-white border border-grey-lightest shadow-md z-50 transform -translate-x-1/2'
    this.selectedText = markdownSerializer.serialize(this.state.selection.content().content)

    render(this.editionMarkup, this.editor)

    this.view.dom.parentNode.appendChild(this.editor)
    autosize(this.editor.querySelector('textarea'))

    let { from, to } = this.state.selection

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

  discardEdition = () => {
    console.log('discard')

    this.editor.remove()
  }

  get editionMarkup() {
    return html`
      <div class="w-full p-4">
        <span class="w-full bg-red-lighter break-words whitespace-normal">${this.selectedText}</span>
        <textarea
          rows="2"
          class="w-full block my-4 border border-grey-lightest p-2 outline-none shadow-none"
          @change=${this.setText}
        ></textarea>
        <div class="flex items-center justify-end">
          <button class="button button--active mr-2" @click=${this.createEdition}>Create</button>
          <button class="button button--default" @click=${this.discardEdition}>Discard</button>
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
    if (state.selection.empty || editions.length > 0) {
      this.tooltip.style.display = 'none'
      return
    }

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

export class ContributionToolbar extends Element {
  name = 'contribution_toolbar'
  mode = 'full'
  selectedText: string

  popupEditor: HTMLElement
  editionText: string

  setText = (e: SyntheticEvent<HTMLTextAreaElement>) => (this.editionText = e.currentTarget.value)

  updateEdition = editionMeta => {
    const edition = new EditionItem(this.editionText, this.selectedText)
    const meta = Object.assign({}, editionMeta, { edition })

    this.editor.view.dispatch(
      this.editor.state.tr.setMeta(editionPlugin, {
        ...meta,
        type: 'updateEdition'
      })
    )
  }

  deleteEdition = editionMeta => {
    this.editor.view.dispatch(
      this.editor.state.tr.setMeta(editionPlugin, {
        type: 'deleteEdition',
        id: editionMeta.spec.edition.id
      })
    )
  }

  editionMarkup = editionMeta => {
    return html`
      <div class="w-full p-4">
        <span class="w-full bg-red-lighter break-words whitespace-normal"
          >${editionMeta.spec.edition.previousText}</span
        >
        <textarea
          rows="2"
          class="w-full block my-4 border border-grey-lightest p-2 outline-none shadow-none"
          @change=${this.setText}
        >
${editionMeta.spec.edition.text}</textarea
        >
        <div class="flex items-center justify-end">
          <button class="button button--active mr-2" @click=${() => this.updateEdition(editionMeta)}>
            Create
          </button>
          <button class="button button--default" @click=${() => this.deleteEdition(editionMeta)}>
            Discard
          </button>
        </div>
      </div>
    `
  }

  handleEdit = (state: EditorState, edition: any) => {
    this.popupEditor = document.createElement('div')
    this.popupEditor.style.width = '700px'
    this.popupEditor.contentEditable = 'false'
    this.popupEditor.className =
      'absolute bg-white border border-grey-lightest shadow-md z-50 transform -translate-x-1/2'
    this.selectedText = edition.spec.edition.text

    render(this.editionMarkup(edition), this.popupEditor)

    this.editor.view.dom.parentNode.appendChild(this.popupEditor)
    autosize(this.popupEditor.querySelector('textarea'))

    let { from, to } = edition

    this.editor.view.dispatch(state.tr.setMeta('highlight', { type: 'add', fromPos: from, toPos: to }))

    // These are in screen coordinates
    let start = this.editor.view.coordsAtPos(from),
      end = this.editor.view.coordsAtPos(to)

    if (this.popupEditor.offsetParent) {
      // The box in which the tooltip is positioned, to use as base
      let box = this.popupEditor.offsetParent.getBoundingClientRect()
      // Find a center-ish x position from the selection endpoints (when
      // crossing lines, end may be more to the left)
      let left = Math.max((start.left + end.left) / 2, start.left + 3)
      this.popupEditor.style.left = left - box.left + 'px'
      this.popupEditor.style.bottom = box.bottom - start.top + 'px'
    }
  }

  get plugins() {
    return [
      new Plugin({
        view(editorView) {
          return new Tooltip(editorView)
        },

        props: {
          decorations: state => {
            const sel = state.selection
            if (!sel.empty) return null
            const editions = editionPlugin.getState(state).editionsAt(sel.from)
            if (!editions.length) return null

            const markup = html`
              ${editions.map(edition => {
                return html`
                  <div class="absolute w-48 top-0 mt-4 bg-green-lighter break-words whitespace-normal mt-4 px-2">
                    ${edition.spec.edition.text}
                    <svg-icon
                      @click=${() => this.handleEdit(state, edition)}
                      class="cursor-pointer"
                      name="edit"
                      width="20"
                      height="20"
                      feather="true"
                      stroke="#fff"
                      color="none"
                    ></svg-icon>
                  </div>
                `
              })}
            `

            const div = document.createElement('div')
            div.className = 'bg-white relative inline-block w-0 overflow-visible align-bottom'

            render(markup, div)
            return DecorationSet.create(state.doc, [Decoration.widget(sel.from, div)])
          }
        }
      })
    ]
  }
}
