// @flow
import type { ComponentType } from 'react'
import React, { PureComponent } from 'react'
import octicons from 'octicons'
import keydown from 'react-keydown'
import Avatar from 'components/avatar'
import Link from 'components/link'

type State = {
  dropdown: boolean
}

type Props = {
  logout_path: string,
  user_path: string,
  avatar: string,
  name: string
}

export default class UserNav extends PureComponent<Props, State> {
  Dropdown: ComponentType<{}> = () => null
  dropdownNode = null

  state = {
    dropdown: false
  }

  async componentDidMount () {
    /* $FlowFixMe */
    this.Dropdown = (await import('components/dropdown')).default
    this.handleDocumentClick()
  }

  handleDocumentClick = () =>
    window.addEventListener('click', (e: SyntheticEvent<Document>) => {
      /* $FlowFixMe */
      if (e.target.parentNode === this.dropdownNode.avatarNode) return
      this.hideDropdown()
    })

  @keydown('esc')
  toggleDropdown () {
    this.setState((state: State) => ({ dropdown: !state.dropdown }))
  }

  hideDropdown () {
    this.setState({ dropdown: false })
  }

  render () {
    const { Dropdown } = this

    return (
      <div className='right-nav flex justify-between'>
        <span
          className='pointer mr3'
          dangerouslySetInnerHTML={{
            __html: octicons['kebab-horizontal'].toSVG({ height: 32 })
          }}
        />

        <Avatar
          ref={node => (this.dropdownNode = node)}
          onClick={this.toggleDropdown.bind(this)}
          src={this.props.avatar}
          name={this.props.name}
        />

        {this.state.dropdown && (
          <Dropdown>
            <ul
              className='nav-links ma0 top-arrow b--light-gray ba list pa4 pl0 pl4 shadow-5 br2'
              style={{ minWidth: '200px' }}
            >
              <li className='pb2'>
                <Link
                  href={this.props.user_path}
                  title='Profile'
                  className='mb2 db dark-gray hover-mid-gray'
                />
              </li>
              <li>
                <Link
                  href={this.props.logout_path}
                  method='patch'
                  className='db dark-gray hover-mid-gray'
                  title='Sign out'
                />
              </li>
            </ul>
          </Dropdown>
        )}
      </div>
    )
  }
}
