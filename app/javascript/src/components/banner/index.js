// @flow

import GetStartedButton from 'components/get-started'
import React from 'react'

type Props = {}

export default (props: Props) => (
  <div className='banner'>
    <h2 className='f2 lh-title'>Join Chuspace</h2>
    <p className='intro f5 lh-copy'>
      Create an account to personalize your homepage, follow your favorite
      authors and publications, applaud stories you love, and more.
    </p>

    <GetStartedButton {...props} login={false} signup />
  </div>
)
