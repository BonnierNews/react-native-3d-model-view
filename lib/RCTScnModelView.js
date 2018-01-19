import React from 'react'
import {
  requireNativeComponent
} from 'react-native'
import {RCTPropTypes} from './PropTypes'

class RCTScnModelView extends React.Component {
  render () {
    return <CustomScnModelView {...this.props} />
  }
}

RCTScnModelView.propTypes = RCTPropTypes
const CustomScnModelView = requireNativeComponent('RCT3DScnModelView', RCTScnModelView)

export default RCTScnModelView
