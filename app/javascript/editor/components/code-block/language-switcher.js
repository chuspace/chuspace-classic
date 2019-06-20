// @flow

/** @jsx h */

import { Component, h, render } from 'preact'

import { MODES } from 'editor/modes'
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

export default class LanguageSwitcher extends Component<Props, State> {
  toolbar: ?HTMLElement

  constructor(props: Props) {
    super(props)

    this.state = {
      mode: props.mode,
      showSwitcher: false
    }
  }

  toggleSwitcher = () =>
    this.setState({
      showSwitcher: !this.state.showSwitcher
    })

  componentDidMount() {
    document.addEventListener('click', (e: MouseEvent) => {
      if (this.toolbar && this.toolbar.contains(e.target)) return
      this.setState({ showSwitcher: false })
    })
  }

  handleLanguageChange = (e: SyntheticInputEvent<HTMLElement>) => {
    e.preventDefault()

    const mode = e.target.dataset.mode
    this.setState({ mode, showSwitcher: false })
    this.props.setMode(mode)
  }

  render() {
    return this.props.readOnly ? (
      <div class="code-editor-language-badge badge--grey mr-4">{this.props.mode}</div>
    ) : (
      <div class="code-editor-language-switcher-container mr-4" ref={node => (this.toolbar = node)}>
        <input type="text" value={this.state.mode} class="input input--slim w-full" onFocus={this.toggleSwitcher} />
        <ul
          class={classNames('code-editor-language-switcher', {
            hidden: !this.state.showSwitcher
          })}
        >
          {MODES.map(({ name, mode }) => (
            <li
              class={classNames('code-editor-language-switcher-mode', { selected: mode === this.state.mode })}
              onClick={this.handleLanguageChange}
              data-mode={mode}
            >
              {name}
            </li>
          ))}
        </ul>
      </div>
    )
  }
}
