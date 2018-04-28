// @flow

import React, { PureComponent } from 'react'

import Avatar from 'components/avatar'
import Button from 'components/button'
import Posts from 'components/posts'

type Props = {
  data: {
    attributes: {
      name: string,
      avatar_large: string,
      nickname: string,
      bio: string,
      company: string,
      website: string,
      location: string
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
      <div className='profile mv5 w-70 center'>
        <div className='sidebar mb5 flex items-center'>
          <div className='flex'>
            <Avatar
              src={user.avatar_large}
              name={user.name}
              onClick={this.changeImage}
            />
          </div>
          <div className='personal pl4 w-75'>
            <h1 className='f4 lh-solid mb0 black-80'>{user.name}</h1>
            <p className='lh-copy mv1 gray f5'>{user.company}</p>
            <p className='lh-copy mt1 black-70 mb0'>{user.bio}</p>
          </div>
          <div className='actions'>
            <Button title='Follow' />
          </div>
        </div>

        <div className='posts'>
          <Posts />
        </div>
      </div>
    )
  }
}
