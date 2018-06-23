// @flow

import React, { PureComponent } from 'react'

import Avatar from 'components/avatar'
import Link from 'components/link'
import octicons from 'octicons'

type Props = {
  postsPath: string,
  user: {
    name: string,
    avatarUrl: string,
    bio: string,
    company: string
  }
}

export default class NewPost extends PureComponent<Props> {
  render () {
    const { user, postsPath } = this.props

    return (
      <div className='editor w-75 center pv5'>
        <div className='flex items-center w-100 mt2'>
          <div className='image'>
            <Avatar name={user.name} src={user.avatarUrl} />
          </div>
          <div className='pl3 w-60'>
            <h1 className='f6 f5-ns fw6 lh-title black mv0'>{user.name}</h1>
            <h2 className='f6 fw4 mt0 mb0 black-60'>{user.bio}</h2>
            <h2 className='f6 fw4 mt0 mb0 black-60'>{user.company}</h2>
          </div>

          <div className='actions f5 w-30 flex items-center justify-between'>
            <span className='black-80'>Draft</span>
            <Link className='green' title='Publish' />
            <Link
              className='brand-primary-red'
              title={
                <div
                  className='f6'
                  dangerouslySetInnerHTML={{
                    __html: octicons.trashcan.toSVG({ class: 'fill-red' })
                  }}
                />
              }
            />
          </div>
        </div>

      </div>
    )
  }
}
