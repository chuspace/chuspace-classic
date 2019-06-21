// @flow

import * as Rails from 'rails-ujs'

import { Controller } from 'stimulus'
import Tooltip from 'tooltip.js'

export default class extends Controller {
  connect() {
    const links = Array.from(document.querySelectorAll('a')).filter(
      link => link.href && !link.href.includes('localhost')
    )

    links.forEach(link => {
      const popper = document.createElement('div')
      popper.classList.add('popper', 'hidden')
      const embedLink = document.createElement('a')
      popper.appendChild(embedLink)
      embedly('defaults', {
        cards: {
          key: 'c4319ad43b644c659fb41d83b6987fa9',
          align: 'center',
          chrome: 0,
          recommend: 0,
          controls: 0
        }
      })
      embedLink.classList.add('embedly-card')
      embedLink.href = link.href

      document.body.appendChild(popper)

      if (!link.href) return
      if (link.href.includes('localhost')) return

      new Tooltip(link, {
        placement: 'top', // or bottom, left, right, and variations
        title: popper.innerHTML,
        html: true,
        closeOnClickOutside: true
      })
    })
  }
}
