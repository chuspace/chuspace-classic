// @flow

import React, { PureComponent } from 'react'

import ChuEditor from 'editor'

type Props = {}

export default class Editor extends PureComponent<Props> {
  handleChange = (content: any) => {
    console.log(content)
  }

  render () {
    return (
      <ChuEditor
        editorId='main'
        placeholder='Start Writing...'
        onChange={this.handleChange}
      />
    )
  }
}
