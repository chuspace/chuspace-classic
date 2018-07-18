import * as plugins from 'editor/plugins'

import { baseKeymap } from 'prosemirror-commands'
import { buildInputRules } from './input-rules'
import { buildKeymap } from './keymaps'
import { history } from 'prosemirror-history'
import { keymap } from 'prosemirror-keymap'

export { buildKeymap } from './keymaps'

export const getBasePlugins = options => {
  const deps = [
    buildInputRules(options.schema),
    keymap(buildKeymap(options.schema, options.mapKeys)),
    keymap(baseKeymap)
  ]
  if (!options.isReadOnly) {
    deps.push(plugins.SelectPlugin)
    deps.push(plugins.LinkPlugin)
  }
  if (options.placeholder) {
    deps.push(plugins.PlaceholderPlugin(options.placeholder))
  }
  if (options.history !== false) {
    deps.push(history())
  }

  return deps
}
