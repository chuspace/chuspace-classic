import React, { PureComponent } from 'react'

import Editor from 'components/editor'
import 'github-markdown-css'

export default class PostsNew extends PureComponent {
  render () {
    const { user } = this.props

    return (
      <div className='editor w-75 center pv5'>
        <div className='dt w-100 bb b--black-05 pb2 mt2'>
          <div className='dtc w3 w4-ns v-mid'>
            <img
              src={user.avatar}
              className='ba b--black-10 db br-100 w3 w4-ns h3 h4-ns'
              alt={user.name}
            />
          </div>
          <div className='dtc v-mid pl3'>
            <h1 className='f6 f5-ns fw6 lh-title black mv0'>{user.name}</h1>
            <h2 className='f6 fw4 mt0 mb0 black-60'>{user.bio}</h2>
            <h2 className='f6 fw4 mt0 mb0 black-60'>{user.company}</h2>
            <h2 className='f6 fw4 mt0 mb0 black-60'>{user.location}</h2>
          </div>
        </div>
        <Editor />
      </div>
    )
  }
}
