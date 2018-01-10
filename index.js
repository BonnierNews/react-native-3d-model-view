import React from 'react'
import {
  requireNativeComponent,
  ViewPropTypes,
  ColorPropType,
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
  color: ColorPropType,
  scale: PropTypes.number,
  onLoadModelStart: PropTypes.func,
  onLoadModelSuccess: PropTypes.func,
  onLoadModelError: PropTypes.func
}

export class ModelView extends React.Component {
  render () {
    console.log(this.props)
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

ARModelView.propTypes = {
  ...propTypes,
  focusSquareColor: ColorPropType,
  focusSquareFillColor: ColorPropType,
  onStart: PropTypes.func,
  onSurfaceFound: PropTypes.func,
  onSurfaceLost: PropTypes.func,
  onSessionInterupted: PropTypes.func,
  onSessionInteruptedEnded: PropTypes.func,
  onPlaceObjectSuccess: PropTypes.func,
  onPlaceObjectError: PropTypes.func,
  trackingQualityInfo: PropTypes.func
}
const RCTARModelView = requireNativeComponent('RCT3DARModelView', ARModelView)
