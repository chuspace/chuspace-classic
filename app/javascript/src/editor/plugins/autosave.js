// @flow

import type { State } from 'slate-react'
import debounce from 'lodash/debounce'

export const delay = (time: number) =>
  debounce((save, state) => {
    save(state)
  }, time)

const func = delay(2000)

export default (save: (*) => void, deBouncer: (any, any) => void = func) => ({
  onChange: (state: State) => {
    deBouncer(save, state)
  }
})
