// @flow
import * as React from 'react'

import type { Change, Value } from 'slate'

import Button from 'components/button'
import Editor from 'editor'
import { Value as EditorValue } from 'slate'
import Fullscreen from 'react-full-screen'
import { State as MarkdownParser } from 'markup-it'
import axiosClient from 'helpers/axios-client'
import classNames from 'classnames'
import html from 'markup-it/lib/html'
import markdown from 'markup-it/lib/markdown'
import to from 'helpers/await-to'

const mdParser = MarkdownParser.create(markdown)
const htmlSerializer = MarkdownParser.create(html)

type Props = {
  value: Value,
  onChange: (change: Change) => void,
  posts_path: string
}

type State = {
  value: Value,
  isFull: boolean
}

export default class EditorComponent extends React.Component<Props, State> {
  constructor (props: Props) {
    super(props)
    const document = mdParser.deserializeToDocument('')

    this.state = {
      value: EditorValue.create({ document }),
      isFull: false
    }
  }

  goFull = () => {
    this.setState({ isFull: !this.state.isFull })
  }

  onChange = ({ value }: Value): void => {
    this.setState({
      value
    }, () => console.log(htmlSerializer.serializeDocument(this.state.value.document)))
  }

  createPost = async (e: SyntheticEvent<HTMLButtonElement>) => {
    e.preventDefault()
    const markdown = mdParser.serializeDocument(this.state.value.document)
    const [error] = await to(
      axiosClient.post(this.props.posts_path, { markdown })
    )

    if (error) console.log(error)
  }

  render () {
    const { isFull, value } = this.state

    const containerClasses = classNames('pa2', {
      'v-100 overflow-y-scroll mt2': isFull,
      'h-auto overflow-y-auto': !isFull
    })

    const editorContainerClasses = classNames('pa2', {
      mt2: isFull,
      ma0: !isFull
    })

    return (
      <Fullscreen
        enabled={isFull}
        onChange={isFull => this.setState({ isFull })}
      >
        <div classes={containerClasses}>
          <div classes={editorContainerClasses}>
            <Editor
              autoFocus
              placeholder='Write your story'
              value={value}
              onChange={this.onChange}
            />
            <Button
              title='Submit'
              onClick={this.createPost}
              className='center bg-black white bn mt3'
            />
          </div>
        </div>
      </Fullscreen>
    )
  }
}
