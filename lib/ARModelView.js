import React from 'react'
import {
  requireNativeComponent,
  ColorPropType
} from 'react-native'
import PropTypes from 'prop-types'
import DefaultPropTypes from './DefaultPropTypes'
import ARManager from './ARManager'

class ARModelView extends React.Component {
  reload () {
    ARManager.reload()
  }

  restart () {
    ARManager.restart()
  }

  getSnapshot () {
    ARManager.getSnapshot()
  }

  render () {
    return <RCTARModelView
      {...this.props}
      />
  }
}

ARModelView.propTypes = {
  ...DefaultPropTypes,
  focusSquareColor: ColorPropType,
  focusSquareFillColor: ColorPropType,
  onStart: PropTypes.func,
  onSurfaceFound: PropTypes.func,
  onSurfaceLost: PropTypes.func,
  onSessionInterupted: PropTypes.func,
  onSessionInteruptedEnded: PropTypes.func,
  onPlaceObjectSuccess: PropTypes.func,
  onPlaceObjectError: PropTypes.func,
  onTrackingQualityInfo: PropTypes.func
}
const RCTARModelView = requireNativeComponent('RCT3DARModelView', ARModelView)

export default ARModelView
