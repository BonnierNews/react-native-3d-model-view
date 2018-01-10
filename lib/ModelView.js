import React from 'react'
import {
  requireNativeComponent,
} from 'react-native'
import DefaultPropTypes from './DefaultPropTypes'

class ModelView extends React.Component {
  render () {
    return <RCTScnModelView
      {...this.props}
      />
  }
}

ModelView.propTypes = DefaultPropTypes
const RCTScnModelView = requireNativeComponent('RCT3DScnModelView', ModelView)

export default ModelView
