export function stringRepeat (text: string, length: number): string {
  let result = ''
  for (let x = 0; x < length; x++) {
    result += text
  }
  return result
}

/**
 * This function escapes all plain-text sequences that might get converted into markdown
 * formatting by Bitbucket server (via python-markdown).
 * @see MarkdownSerializerState.esc()
 */
export function escapeMarkdown (str: string, startOfLine?: boolean): string {
  let strToEscape = str || ''
  strToEscape = strToEscape.replace(/[`*\\+_|()[\]{}]/g, '\\$&')
  if (startOfLine) {
    strToEscape = strToEscape
      .replace(/^[#-&(-*]/, '\\$&') // Don't escape ' character
      .replace(/^(\d+)\./, '$1\\.')
  }
  return strToEscape
}
