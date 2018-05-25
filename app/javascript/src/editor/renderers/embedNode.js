// @ flow

/* global embedly */

import React from 'react'

if (typeof window !== 'undefined') {
  ;(function (w, d) {
    const id = 'embedly-platform'
    const n = 'script'
    if (!d.getElementById(id)) {
      w.embedly =
        w.embedly ||
        function () {
          ;(w.embedly.q = w.embedly.q || []).push(arguments)
        }
      var e = d.createElement(n)
      e.id = id
      e.async = 1
      e.src =
        (document.location.protocol === 'https:' ? 'https' : 'http') +
        '://cdn.embedly.com/widgets/platform.js'
      var s = d.getElementsByTagName(n)[0]
      s.parentNode.insertBefore(e, s)
    }
  })(window, document)
}

export default class EmbedNode extends React.Component {
  state = {
    response: null
  }

  embed (el) {
    if (el) embedly('card', el)
  }

  render () {
    const { attributes } = this.props
    return (
      <a
        {...attributes}
        href={this.props.options.getHref(this.props.node)}
        data-card-key='227fa5d8a5cc4ccba3db93b52b1a5238'
        data-card-controls='0'
        data-card-recommend='0'
        ref={this.embed}
      />
    )
  }
}
