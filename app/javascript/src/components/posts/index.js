import React, { PureComponent } from 'react'

export default class PostsIndex extends PureComponent {
  render () {
    return (
      <section className='mw7 center pv5'>
        <h2 className='athelas ph3 ph0-l'>News</h2>
        <article className='pv4 bt bb b--black-10 ph3 ph0-l'>
          <div className='flex flex-column flex-row-ns'>
            <div className='w-100 w-60-ns pr3-ns order-2 order-1-ns'>
              <h1 className='f3 athelas mt0 lh-title'>
                Tech Giant Invests Huge Money to Build a Computer Out of Science
                Fiction
              </h1>
              <p className='f5 f4-l lh-copy athelas'>
                The tech giant says it is ready to begin planning a quantum
                computer, a powerful cpu machine that relies on subatomic
                particles instead of transistors.
              </p>
            </div>
            <div className='pl3-ns order-1 order-2-ns mb4 mb0-ns w-100 w-40-ns'>
              <img
                src='http://mrmrs.github.io/photos/cpu.jpg'
                className='db'
                alt='Photo of a dimly lit room with a computer interface terminal.'
              />
            </div>
          </div>
          <p className='f6 lh-copy gray mv0'>
            By <span className='ttu'>Robin Darnell</span>
          </p>
          <time className='f6 db gray'>Nov. 21, 2016</time>
        </article>
      </section>
    )
  }
}
