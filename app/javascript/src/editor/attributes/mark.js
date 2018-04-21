import { FONTSIZE, LETTERSPACING } from 'editor/constants/marks'

const markAttrs = {
  backgroundColor: mark => mark.data.getIn(['color', 'color']),
  color: mark => mark.data.getIn(['color', 'color']),
  fontSize: mark => mark.data.get(FONTSIZE),
  letterSpacing: mark => mark.data.get(LETTERSPACING)
}

export default markAttrs
