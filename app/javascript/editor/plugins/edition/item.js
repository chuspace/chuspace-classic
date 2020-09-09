// @flow

export default class Item {
  id: number
  previousText: string
  text: string
  state: 'draft' | 'saved' | 'merged' | 'rejected'

  constructor(text: string, previousText: string) {
    this.id = Math.floor(Math.random() * 0xffffffff)
    this.previousText = previousText
    this.text = text
    this.state = 'saved'
  }
}
