// @flow

/** @jsx h */

import './image.sass'

import { Component, Fragment, h, render } from 'preact'

import LazyLoad from 'vanilla-lazyload'
import { useEffect } from 'preact/hooks'

type Props = {
  attrs: any,
  options: any
}

if (document && !document.lazyLoadInstance) {
  document.lazyLoadInstance = new LazyLoad({
    elements_selector: '.lazy',
    load_delay: 300
  })
}

const Image = (props: Props) => {
  const attrs = props.attrs
  const options = props.options
  const imageUrl = attrs.src
  const figFloat = attrs.align === 'left' || attrs.align === 'right' ? attrs.align : 'none'
  let figMargin = '0em auto 1em'

  if (attrs.align === 'left') {
    figMargin = '1em 1em 1em 0px'
  }

  if (attrs.align === 'right') {
    figMargin = '1em 0px 1em 1em'
  }

  const figWidth = attrs.align === 'full' ? '100%' : `${attrs.size}%`
  const figStyle = {
    width: figWidth,
    margin: figMargin,
    float: figFloat
  }

  useEffect(() => document && document.lazyLoadInstance.update())

  return (
    <Fragment>
      <img alt={attrs.caption} class="lazy" data-src={imageUrl} />
      <figcaption>
        <input
          type="text"
          onChange={e => props.handleAltChange(e.target.value)}
          class="input input--slim input--borderless text-center text-sm font-headings"
          autofocus={props.isSelected}
          defaultValue={attrs.alt}
          maxLength={70}
          placeholder="Click to enter caption"
        />
      </figcaption>
    </Fragment>
  )
}

export default Image
