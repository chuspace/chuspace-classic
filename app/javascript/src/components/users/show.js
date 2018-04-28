// @flow

import React, { PureComponent } from 'react'

import Avatar from 'components/avatar'

type Props = {
  data: {
    attributes: {
      name: string,
      avatar_large: string
    }
  }
}

export default class UserProfile extends PureComponent<Props> {
  changeImage = e => {
    console.log(e)
  }

  render () {
    const { attributes: user } = this.props.data

    return (
      <div className='profile'>
        <div className='sidebar'>
          <Avatar
            src={user.avatar_large}
            name={user.name}
            size='huge'
            onClick={this.changeImage}
          />
        </div>

        <div className='posts' />
      </div>
    )
  }
}
