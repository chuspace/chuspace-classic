// @flow

import { LANGUAGES } from 'editor/constants'
import type { LanguageType } from 'editor/constants'

const modes = LANGUAGES.filter(
  language => language.mode && language.mode !== 'auto' && language.mode !== 'text' && language.mode !== 'javascript'
).forEach((language: LanguageType) =>
  /* $FlowFixMe */
  language.custom ? import(`./${language.mode}`) : import(`codemirror/mode/${language.mode}/${language.mode}`)
)

export default modes
