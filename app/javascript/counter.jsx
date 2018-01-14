import React, { Component } from 'react'

export default class Counter extends Component {
  state = {
    count: 0
  }

  increment = e => {
    e.preventDefault()
    this.setState({ count: this.state.count + 1 })
  }

  decrement = e => {
    e.preventDefault()
    this.setState({ count: this.state.count - 1 })
  }

  render () {
    return (
      <div>
        <p>Count: {this.state.count}</p>
        <button onClick={this.increment}>+</button>
        <button onClick={this.decrement}>-</button>
      </div>
    )
  }
}
