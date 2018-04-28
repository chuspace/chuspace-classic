// @flow
import type { Element } from 'react'
import React from 'react'
import classNames from 'classnames'
import initials from 'initials'

type Props = {
  name: string,
  align: 'left' | 'right' | 'none',
  src?: string | null,
  onClick?: (e: SyntheticEvent<HTMLDivElement>) => void,
  className?: string
}

export default class Avatar extends React.PureComponent<Props> {
  static defaultProps = {
    align: 'none'
  }

  avatarNode: null | HTMLElement = null

  colors = [
    { color: '#FFA13F', borderColor: '#FECD3D', backgroundColor: '#FDFAEF' },
    { color: '#0DDAA7', borderColor: '#0DDAA7', backgroundColor: '#F3FEFC' },
    { color: '#FF6A56', borderColor: '#FFC7B5', backgroundColor: '#FDF7F6' },
    { color: '#45ABF8', borderColor: '#B2D1F4', backgroundColor: '#D3EEFD' }
  ]

  seed (): number {
    if (!this.props.name) return 0

    return (
      [...this.props.name].reduce(
        (seed, char) => seed + char.charCodeAt(0),
        0
      ) % this.colors.length
    )
  }

  styles (): {} | null {
    return this.colors[this.seed()]
  }

  anonymousStyles () {
    if (this.props.src) return {}

    return {
      borderWidth: '1px',
      borderStyle: 'solid',
      ...this.styles()
    }
  }

  renderAvatar (): Element<any> {
    return <img className='br2' src={this.props.src} />
  }

  renderInitials (): string {
    const name = /\s/.test(this.props.name)
      ? this.props.name
      : this.props.name[0]

    return initials(name).toUpperCase()
  }

  render () {
    return (
      <span
        ref={node => (this.avatarNode = node)}
        onClick={this.props.onClick}
        className={classNames('br2', this.props.className)}
        style={this.anonymousStyles()}
      >
        {this.props.src ? this.renderAvatar() : this.renderInitials()}
      </span>
    )
  }
}
