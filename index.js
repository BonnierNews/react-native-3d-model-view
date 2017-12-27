import React from 'react'
import {
  requireNativeComponent,
  ViewPropTypes
} from 'react-native'
import PropTypes from 'prop-types'

class ModelView extends React.Component {
  render () {
    return <RNModelView {...this.props} />
  }
}

ModelView.propTypes = {
  ...ViewPropTypes,
  animate: PropTypes.bool,
  allowAr: PropTypes.bool,

  model: PropTypes.obj.isRequired,

  rotateX: PropTypes.number,
  rotateY: PropTypes.number,
  rotateZ: PropTypes.number,

  scale: PropTypes.number,

  scaleX: PropTypes.number,
  scaleY: PropTypes.number,
  scaleZ: PropTypes.number,

  translateX: PropTypes.number,
  translateY: PropTypes.number,
  translateZ: PropTypes.number
}

const RNModelView = requireNativeComponent('RNModelView', ModelView)

export default ModelView
