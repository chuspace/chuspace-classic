/* global iframely */

import React from 'react'
import axios from 'axios'

async function getEmbed (url) {
  try {
    const response = await axios.get('http://iframe.ly/api/iframely', {
      params: {
        api_key: '376392514861f59ada33d2',
        iframe: true,
        iframely: 'less',
        omit_script: true,
        omit_css: true,
        url
      }
    })
    return response
  } catch (error) {
    return error
  }
}

export default class Video extends React.Component {
  state = {
    iframelyEmbedHtmlCode: null
  }

  async componentWillMount () {
    window.iframely && iframely.load()
    const response = await getEmbed(this.props.options.getHref(this.props.node))
    this.setState({ iframelyEmbedHtmlCode: response.data.html })
    console.log(response)
  }

  render () {
    let { attributes } = this.props

    return (
      <span
        {...attributes}
        ref={this.embed}
        dangerouslySetInnerHTML={{ __html: this.state.iframelyEmbedHtmlCode }}
      />
    )
  }
}
