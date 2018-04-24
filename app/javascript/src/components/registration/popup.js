// @flow

import Modal from 'components/modal'
import type { Props } from './index'
import React from 'react'
import Registration from './index'

export default (props: Props) => (
  <Modal {...props} hide={props.hideSignup} className='brand-bg-green'>
    <Registration {...props} />
  </Modal>
)
