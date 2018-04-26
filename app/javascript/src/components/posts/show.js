import React, { PureComponent } from 'react'
import { State } from 'markup-it'
import markdown from 'markup-it/lib/markdown'
import html from 'markup-it/lib/html'

import 'github-markdown-css'

export default class PostsShow extends PureComponent {
  render () {
    const parser = State.create(markdown)
    const doc = parser.deserializeToDocument(this.props.body)
    const htmlSerializer = State.create(html)
    const htmlStr = htmlSerializer.serializeDocument(doc)

    return (
      <div
        className='w-75 center pv5 markdown-body'
        dangerouslySetInnerHTML={{ __html: htmlStr }}
      />
    )
  }
}
