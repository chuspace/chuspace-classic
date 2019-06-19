// @flow

/** @jsx h */

import { Component, h, render } from 'preact'

import { MODES } from 'editor/modes'

type Props = {
  mode: string,
  readOnly: boolean,
  setMode: (mode: string) => Promise<any>
}

type State = {
  mode: string,
  showSwitcher: boolean
}

export default class LanguageSwitcher extends Component<Props, State> {
  constructor(props: Props) {
    super(props)

    this.state = {
      mode: props.mode,
      showSwitcher: false
    }
  }

  toggleSwitcher = (e: Event) => {
    this.setState({
      showSwitcher: !this.state.showSwitcher
    })
  }

  handleLanguageChange = e => {
    e.preventDefault()

    const mode = e.target.dataset.mode
    this.setState({ mode, showSwitcher: false })
    this.props.setMode(mode)
  }

  render() {
    return this.props.readOnly ? (
      <div class="code-editor-language-badge badge--grey mr-4">{this.props.mode}</div>
    ) : (
      <div class="code-editor-language-switcher-container mr-4">
        <input type="text" value={this.state.mode} class="input input--slim w-full" onFocus={this.toggleSwitcher} />
        {this.state.showSwitcher && (
          <ul class="code-editor-language-switcher">
            {MODES.map(({ name, mode }) => (
              <li onClick={this.handleLanguageChange} data-mode={mode}>
                {name}
              </li>
            ))}
          </ul>
        )}
      </div>
    )
  }
}
