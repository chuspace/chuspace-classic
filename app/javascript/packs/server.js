import context from '../context'
import Counter from '../counter'
import HelloReact from '../hello_react'

const ctx = context()
ctx.Counter = Counter
ctx.HelloReact = HelloReact
