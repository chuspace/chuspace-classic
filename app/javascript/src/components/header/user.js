import React, { PureComponent } from 'react'
import octicons from 'octicons'

import Link from 'components/link'

export default class UserNav extends PureComponent {
  render () {
    return (
      <div className='right-nav'>
        <div className='dropdown-icon relative'>
          <span
            dangerouslySetInnerHTML={{
              __html: octicons['kebab-horizontal'].toSVG({ height: 32 })
            }}
          />

          <div className='dropdown absolute right-0 top-1'>
            <ul
              className='nav-links b--light-gray ba list pa4 pl0 pl4 shadow-5 br2'
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
          </div>
        </div>
      </div>
    )
  }
}
