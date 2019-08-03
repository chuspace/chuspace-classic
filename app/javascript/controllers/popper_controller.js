// @flow

import 'tippy.js/themes/light.css'

import * as Rails from 'rails-ujs'
import * as iframely from '@iframely/embed.js'

import { html, render } from 'lit-html'

import { Controller } from 'stimulus'
import tippy from 'tippy.js'
import truncate from 'lodash/truncate'

export default class PopperController extends Controller {
  tooltipMarkup = (url: string, data: any) => {
    const node = document.createElement('div')

    const template = html`
      <a href=${url} class="block link link--default" rel="noopener noreferrer" target="_blank">
        <div class="flex items-center py-2">
          <div class="popover-media mr-4 w-1/3">
            <lazy-image
              src=${data.thumbnail_url}
              alt=${data.title}
              align="none"
              editable="false"
              title=${data.title}
            ></lazy-image>
          </div>
          <div class="popover-content text-left w-2/3">
            <h1 class="text-base mb-2 font-bold">${data.title}</h1>

            <p>${truncate(data.description, { length: 70 })}</p>
            <small class="block mt-2 font-bold">${data.provider_name}</small>
          </div>
        </div>
      </a>
    `

    render(template, node)

    return node.innerHTML
  }

  connect() {
    window.iframely &&
      window.iframely.extendOptions({ api_key: '376392514861f59ada33d2', omit_script: 1, omit_css: 1, iframe: 1 })

    const postBody = document.querySelector('.chu-editor')
    const links = Array.from(postBody.querySelectorAll('a'))

    const INITIAL_CONTENT = `<div class='flex' style="margin:5px 0;">
      <content-loader type="image" class='w-1/3 mr-2' width='200' height='200'></content-loader>
      <content-loader lines="3" class='w-2/3 mt-4' width="200" height='200'></content-loader>
    </div>`

    tippy(links, {
      content: INITIAL_CONTENT,
      animation: 'scale',
      animateFill: false,
      theme: 'light',
      delay: 500,
      maxWidth: 350,
      lazy: true,
      interactive: true,
      arrow: true,
      flipOnUpdate: true,
      onShow: async instance => {
        if (instance.state.isFetching === true || instance.state.canFetch === false) {
          return
        }

        instance.state.isFetching = true
        instance.state.canFetch = false
        const href = instance.reference.href
        instance.popper.style.width = '350px'

        try {
          const response = await fetch(
            `//iframe.ly/api/oembed?api_key=376392514861f59ada33d2&url=${href}&omit_script=1&iframe=card&omit_css=1`
          )

          const data = await response.json()
          if (!data.title) throw new Error(data)

          if (!instance.state.isVisible) {
            return
          }

          instance.setContent(this.tooltipMarkup(href, data))
        } catch (error) {
          instance.setContent('Link preview unavailable')
        } finally {
          instance.state.isFetching = false
        }
      },
      onHidden(instance) {
        const { tooltip } = instance.popperChildren
        instance.state.canFetch = true
      }
    })
  }
}
