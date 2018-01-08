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

const propTypes = {
  ...ViewPropTypes,
  source: PropTypes.string.isRequired,
  name: PropTypes.string.isRequired,
  type: PropTypes.number.isRequired,
  onLoadModelStart: PropTypes.func,
  onLoadModelSuccess: PropTypes.func,
  onLoadModelError: PropTypes.func
}

export class ModelView extends React.Component {
  render () {
    return <RCTScnModelView
      {...this.props}
      />
  }
}

ModelView.propTypes = propTypes
const RCTScnModelView = requireNativeComponent('RCT3DScnModelView', ModelView)

export class ARModelView extends React.Component {
  render () {
    return <RCTARModelView
      {...this.props}
      />
  }
}

ARModelView.propTypes = propTypes
const RCTARModelView = requireNativeComponent('RCT3DARModelView', ARModelView)
