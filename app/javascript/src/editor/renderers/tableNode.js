// @flow
/* eslint-disable react/display-name */
import * as React from 'react'

import mapValues from 'lodash/mapValues'

export const tableNode = options => {
  return (props: nodeProps) => {
    return <Table {...props} tableOptions={options} />
  }
}

export const tableRowNode = () => {
  return ({ attributes, children }: nodeProps) => {
    return <tr {...attributes}>{children}</tr>
  }
}

export const tableCellNode = stylesAttr => {
  return ({ attributes, children, node }: nodeProps) => {
    return (
      <td
        style={Object.assign(mapValues(stylesAttr, val => val && val(node)), {
          minWidth: '50px'
        })}
        {...attributes}
      >
        {children}
      </td>
    )
  }
}
