// @flow

import { LANGUAGE_MODE_HASH, MODES } from 'editor/modes'
import { LitElement, customElement, html } from 'lit-element'

import classNames from 'classnames'

type Props = {
  mode: string,
  readOnly: boolean,
  setMode: (mode: string) => Promise<any>
}

type State = {
  mode: string,
  showSwitcher: boolean
}

export default class LanguageSwitcher extends LitElement<Props, State> {
  static get properties() {
    return {
      mode: { type: String, reflect: true },
      setMode: { type: Function },
      showSwitcher: { type: Boolean },
      readonly: { type: String }
    }
  }

  constructor(props: Props) {
    super()
    this.showSwitcher = false
  }

  toggleSwitcher = () => (this.showSwitcher = !this.showSwitcher)

  connectedCallback() {
    super.connectedCallback()

    try {
      this.readonly = JSON.parse(this.readonly)
    } catch (e) {}

    document.addEventListener('click', (e: MouseEvent) => {
      const el = e.target
      const toolbar = this.querySelector('.code-editor-language-switcher-container')
      if (toolbar && el && toolbar.contains(el)) return
      this.showSwitcher = false
    })
  }

  handleLanguageChange = (e: SyntheticInputEvent<HTMLElement>) => {
    e.preventDefault()

    this.mode = e.target.dataset.mode
    this.setMode(this.mode)
    this.showSwitcher = false

    this.requestUpdate()
  }

  createRenderRoot() {
    return this
  }

  render() {
    const { name } = LANGUAGE_MODE_HASH[this.mode]

    return this.readonly
      ? html`
          <div class="code-editor-language-badge badge--grey mr-4">${this.mode}</div>
        `
      : html`
          <div class="code-editor-language-switcher-container mr-4">
            <input type="text" value=${name} class="input input--slim w-full" @focus=${this.toggleSwitcher} />
            <ul
              class=${classNames('code-editor-language-switcher', {
                hidden: !this.showSwitcher
              })}
            >
              ${MODES.map(
                ({ name, mode }) => html`
                  <li
                    class=${classNames('code-editor-language-switcher-mode', { selected: mode === this.mode })}
                    @click=${this.handleLanguageChange}
                    data-mode=${mode}
                  >
                    ${name}
                  </li>
                `
              )}
            </ul>
          </div>
        `
  }
}

document.addEventListener('turbolinks:load', () => {
  if (!window.customElements.get('code-editor-language-switcher')) {
    customElements.define('code-editor-language-switcher', LanguageSwitcher)
  }
})
