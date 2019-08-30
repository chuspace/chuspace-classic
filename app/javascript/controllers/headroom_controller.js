// @flow

import * as Headroom from 'headroom.js'

import { Controller } from 'stimulus'

export default class extends Controller {
  initialize() {
    this.headroom = new Headroom(this.element, {
      offset: 205,
      tolerance: 5,
      classes: {
        initial: 'animated',
        pinned: 'slideInDown',
        unpinned: 'slideOutUp',
        top: 'header--top',
        notTop: 'header--not-top',
        bottom: 'header--bottom',
        notBottom: 'header--not-bottom'
      }
    })
    this.headroom.init()
  }

  disconnect() {
    this.headroom.destroy()
  }
}
