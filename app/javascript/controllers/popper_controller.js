// @flow

import 'tippy.js/themes/light.css'

import * as Rails from 'rails-ujs'
import * as iframely from '@iframely/embed.js'

import { Controller } from 'stimulus'
import tippy from 'tippy.js'

export default class extends Controller {
  applyStyles = (popper, tooltip) => {
    // Because the tooltip has `position: absolute`,
    // it no longer affects the parent popper's layout.
    // We need to explicitly give it a width.
    popper.style.width = '400px'

    // Setup transition styles on the tooltip itself
    tooltip.style.transitionDuration = '0.2s'
    tooltip.style.transitionProperty = 'visibility, opacity, height'
  }

  animateHeight = (instance, instanceContent) => {
    const { popper } = instance
    const { tooltip, content } = instance.popperChildren

    if (!instanceContent) {
      instance.destroy()
      return
    }

    function onTransitionEnd(event) {
      if (event.target === event.currentTarget) {
        content.style.opacity = '1'
        instance.setContent(instanceContent)
      }
    }

    // Wait until the height transition has finished before
    // fading the content in. Since we have `overflow: hidden`
    // on the tooltip this isn't actually needed, but if you
    // have an arrow element it will be.
    if (!instance._transitionEndListener) {
      instance._transitionEndListener = onTransitionEnd
    }

    tooltip.addEventListener('transitionend', onTransitionEnd)

    // Store the base height of the tooltip when it has the
    // initial Loading... content.
    if (!instance._baseHeight) {
      instance._baseHeight = tooltip.clientHeight
    }

    // Here is where we find out the height of the tooltip
    // when it has the content. We could technically hardcode
    // 200px as the value, but it's useful to know how to do
    // this with dynamic content.
    content.style.opacity = '0'

    // Temporarily set the image as the tooltip's content
    // so we can find out the final height of the tooltip.
    instance.setContent(instanceContent)
    window.iframely.load()

    const height = tooltip.clientHeight
    // Apply the height to the parent popper element.
    popper.style.height = height + 'px'

    // Reset the tooltip's height to the base height.
    tooltip.style.height = instance._baseHeight + 'px'

    // Cause reflow so we can start the height transition.
    void tooltip.offsetHeight

    // Start the transition.
    tooltip.style.height = height + 'px'

    // Remove the Loading... content and wait until the
    // transition finishes.
    instance.setContent('')
  }
  connect() {
    window.iframely && window.iframely.extendOptions({ api_key: '376392514861f59ada33d2', omit_script: 1, iframe: 1 })
    // embedly('defaults', {
    //   cards: {
    //     key: 'c4319ad43b644c659fb41d83b6987fa9',
    //     align: 'center',
    //     chrome: 0,
    //     recommend: 0,
    //     controls: 0
    //   }
    // })

    const links = Array.from(document.querySelectorAll('a')).filter(
      link => link.href && !link.href.includes('localhost')
    )

    const INITIAL_CONTENT = '<div style="margin:5px 0;">Loading...</div>'

    tippy(links, {
      content: INITIAL_CONTENT,
      animation: 'scale',
      animateFill: false,
      theme: 'light',
      interactive: true,
      arrow: true,
      flipOnUpdate: true,
      onShow: async instance => {
        if (instance.state.isFetching === true || instance.state.canFetch === false) {
          return
        }

        instance.state.isFetching = true
        instance.state.canFetch = false

        this.applyStyles(instance.popper, instance.popperChildren.tooltip)

        try {
          const response = await fetch(
            `//iframe.ly/api/oembed?api_key=376392514861f59ada33d2&url=${instance.reference.href}&omit_script=1&iframe=card&omit_css=1`
          )
          const json = await response.json()

          // If the tooltip hid before finishing the request, stop further action
          if (!instance.state.isVisible) {
            return
          }

          this.animateHeight(instance, json.html)
        } catch (error) {
          instance.setContent('An error occurred')
        } finally {
          instance.state.isFetching = false
        }
      },
      onHidden(instance) {
        const { tooltip } = instance.popperChildren
        instance.state.canFetch = true
        instance.setContent(INITIAL_CONTENT)
        tooltip.style.height = null
        tooltip.removeEventListener('transitionend', instance._transitionEndListener)
        instance._transitionEndListener = null
      }
    })
  }
}
