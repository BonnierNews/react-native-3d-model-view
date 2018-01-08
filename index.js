import React from 'react'
import {
  requireNativeComponent,
  ViewPropTypes,
  NativeModules
} from 'react-native'
import PropTypes from 'prop-types'

export const Manager = NativeModules['3DModelManager']
export const ModelTypes = {
  SCN: 1,
  OBJ: 2
}

class ModelView extends React.Component {
  render () {
    return <RCTModelView
      {...this.props}
      />
  }
}

ModelView.propTypes = {
  ...ViewPropTypes,
  source: PropTypes.string.isRequired,
  name: PropTypes.string.isRequired,
  type: PropTypes.number.isRequired,
  onLoadModelStart: PropTypes.func,
  onLoadModelSuccess: PropTypes.func,
  onLoadModelError: PropTypes.func
}

const RCTModelView = requireNativeComponent('RCT3DModelView', ModelView)

export default ModelView
