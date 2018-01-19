import React from 'react'
import {
  requireNativeComponent
} from 'react-native'
import { RCTPropTypes, ARPropTypes } from './PropTypes'

class RCTARModelView extends React.Component {
  render () {
    return <CustomARModelView {...this.props} />
  }
}

RCTARModelView.propTypes = {
  ...RCTPropTypes,
  ...ARPropTypes
}
const CustomARModelView = requireNativeComponent('RCT3DARModelView', RCTARModelView)

export default RCTARModelView
