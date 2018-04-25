// @flow
import * as React from 'react'

import Button from 'components/button'
import Fullscreen from 'react-full-screen'
import Textarea from 'components/textarea'
import axiosClient from 'helpers/axios-client'
import classNames from 'classnames'
import to from 'helpers/await-to'

type Props = {
  onChange: (change: Change) => void,
  posts_path: string
}

type State = {
  isFull: boolean
}

export default class Editor extends React.Component<Props, State> {
  constructor (props: Props) {
    super(props)

    this.state = {
      value: '',
      isFull: false
    }
  }

  goFull = () => {
    this.setState({ isFull: !this.state.isFull })
  }

  onChange = (e): void => {
    console.log(e.target.value)
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
            <Textarea
              autoFocus
              rows={10}
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
