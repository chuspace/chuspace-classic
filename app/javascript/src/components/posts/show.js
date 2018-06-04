import 'github-markdown-css'

import React, { PureComponent } from 'react'

export default class PostsShow extends PureComponent {
  render () {
    return (
      <div
        className='mw7 center pv5 markdown-body'
        dangerouslySetInnerHTML={{ __html: this.props.body }}
      />
    )
  }
}
