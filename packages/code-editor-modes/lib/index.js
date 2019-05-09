// @flow

import type { LanguageType } from './modes'
import { MODES } from './modes'

export const DEFAULT_MODE: string = 'auto'

export const loadMode = async (mode: string) => {
  const language: ?LanguageType = MODES.filter(
    language => language.mode && language.mode !== 'auto' && language.mode !== 'text' && language.mode !== 'javascript'
  ).find((language: LanguageType) => language.mode === mode)

  if (language) {
    language.custom
      ? /* $FlowFixMe */
        await import(`./custom/${language.mode}`)
      : /* $FlowFixMe */
        await import(`codemirror/mode/${language.mode}/${language.mode}`)
  }

  return language
}

export { MODES }
