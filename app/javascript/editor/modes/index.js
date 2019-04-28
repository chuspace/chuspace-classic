// @flow

import { LANGUAGES } from 'editor/constants'
import type { LanguageType } from 'editor/constants'

const loadMode = async (mode: string) => {
  const language: ?LanguageType = LANGUAGES.filter(
    language => language.mode && language.mode !== 'auto' && language.mode !== 'text' && language.mode !== 'javascript'
  ).find((language: LanguageType) => language.mode === mode)

  if (language) {
    language.custom
      ? /* $FlowFixMe */
        await import(`./${language.mode}`)
      : /* $FlowFixMe */
        await import(`codemirror/mode/${language.mode}/${language.mode}`)
  }

  return language
}

export default loadMode
